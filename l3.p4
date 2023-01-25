#include <core.p4>
#include <psa.p4>

const bit<16> ETHERTYPE_TPID = 0x8100;
const bit<16> ETHERTYPE_IPV4 = 0x0800;

/* Define all the headers the program will recognize
 * The actual sets of headers processed by each gress can differ
 */

header ethernet_h {
	bit<48>   dst_addr;
	bit<48>   src_addr;
	bit<16>   ether_type;
}

header vlan_tag_h {
	bit<16> pcp_cfi_vid;
	bit<16>  ether_type;
}

header ipv4_h {
	bit<8>       version_ihl;
	bit<8>       diffserv;
	bit<16>      total_len;
	bit<16>      identification;
	bit<16>      flags_frag_offset;
	bit<8>       ttl;
	bit<8>       protocol;
	bit<16>      hdr_checksum;
	bit<32>      src_addr;
	bit<32>      dst_addr;
}

const int IPV4_HOST_SIZE = 65536;

typedef bit<48> ethernet_addr_t;

struct my_ingress_headers_t {
	ethernet_h   ethernet;
	vlan_tag_h   vlan_tag;
	ipv4_h       ipv4;
}

struct my_ingress_metadata_t {
}

struct empty_metadata_t {
}

parser Ingress_Parser(
	packet_in pkt,
	out my_ingress_headers_t hdr,
	inout my_ingress_metadata_t meta,
	in psa_ingress_parser_input_metadata_t ig_intr_md,
	in empty_metadata_t resub_meta,
	in empty_metadata_t recirc_meta)
{
	 state start {
		transition parse_ethernet;
	}

	state parse_ethernet {
		pkt.extract(hdr.ethernet);
		transition select(hdr.ethernet.ether_type) {
			ETHERTYPE_TPID:  parse_vlan_tag;
			ETHERTYPE_IPV4:  parse_ipv4;
			default: accept;
		}
	}

	state parse_vlan_tag {
		pkt.extract(hdr.vlan_tag);
		transition select(hdr.vlan_tag.ether_type) {
			ETHERTYPE_IPV4:  parse_ipv4;
			default: accept;
		}
	}

	state parse_ipv4 {
		pkt.extract(hdr.ipv4);
		transition accept;
	}

}

control ingress(
	inout my_ingress_headers_t hdr,
	inout my_ingress_metadata_t meta,
	in psa_ingress_input_metadata_t ig_intr_md,
	inout psa_ingress_output_metadata_t ostd
)
{
	/*
	 * If got match -> egress
	 * to port 1 else drop
	 */
	action send(PortId_t port, ClassOfService_t class) {
		ostd.egress_port = (PortId_t) port;
		ostd.drop = false;
		ostd.class_of_service = (ClassOfService_t) class;
	}

	/* This is workaround due to probably p4c-dpdk bug.
	 * Details can be see here:
	 * https://github.com/p4lang/p4c/issues/3861
	 * This line need to be "ostd.drop = true;"
	 */
	action drop() {
		ostd.drop = true;
	}
	
	action set_port_and_src_mac( PortId_t port,
								 ethernet_addr_t src_mac,
								 ethernet_addr_t dst_mac) {
	send_to_port(ostd, port);
		hdr.ethernet.src_addr = src_mac;
		hdr.ethernet.dst_addr = dst_mac;
	}

	table ipv4_host {
		key = { hdr.ipv4.dst_addr : exact; }
		actions = {
			send;drop;
			@defaultonly NoAction;
		}

		const default_action = NoAction();

		size = IPV4_HOST_SIZE;
	}


	apply {
				ipv4_host.apply();
	}
}

control Ingress_Deparser(packet_out pkt,
	out empty_metadata_t clone_i2e_meta,
	out empty_metadata_t resubmit_meta,
	out empty_metadata_t normal_meta,
	inout my_ingress_headers_t hdr,
	in    my_ingress_metadata_t meta,
	in psa_ingress_output_metadata_t istd)
{
	apply {
		pkt.emit(hdr);
	}
}

struct my_egress_headers_t {
}

struct my_egress_metadata_t {
}

parser Egress_Parser(
	packet_in pkt,
	out my_egress_headers_t hdr,
	inout my_ingress_metadata_t meta,
	in psa_egress_parser_input_metadata_t istd,
	in empty_metadata_t normal_meta,
	in empty_metadata_t clone_i2e_meta,
	in empty_metadata_t clone_e2e_meta)
{
	state start {
		transition accept;
	}
}

control egress(
	inout my_egress_headers_t hdr,
	inout my_ingress_metadata_t meta,
	in psa_egress_input_metadata_t istd,
	inout psa_egress_output_metadata_t ostd)
{
	apply {
	}
}

control Egress_Deparser(packet_out pkt,
	out empty_metadata_t clone_e2e_meta,
	out empty_metadata_t recirculate_meta,
	inout my_egress_headers_t hdr,
	in my_ingress_metadata_t meta,
	in psa_egress_output_metadata_t istd,
	in psa_egress_deparser_input_metadata_t edstd)
{
	apply {
		pkt.emit(hdr);
	}
}

#if __p4c__
bit<32> test_version = __p4c_version__;
#endif

IngressPipeline(Ingress_Parser(), ingress(), Ingress_Deparser()) pipe;

EgressPipeline(Egress_Parser(), egress(), Egress_Deparser()) ep;

PSA_Switch(pipe, PacketReplicationEngine(), ep, BufferingQueueingEngine()) main;
