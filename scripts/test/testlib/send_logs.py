import socket


conn_target = None
udp_socket = None
tcp_socket = None

bundle_size = 256
bundle_cache = []

def udp_connect(host, port):
    global conn_target
    global udp_socket

    udp_socket = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    ipaddr = socket.gethostbyname(host)
    conn_target = (ipaddr, port)

def send_udp(log):
    global udp_socket, conn_target
    udp_socket.sendto(log, conn_target)

def tcp_connect(host, port):
    global tcp_socket
    global conn_target

    try:
        tcp_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        ipaddr = socket.gethostbyname(host)
        conn_target = (ipaddr, port)
        tcp_socket.connect(conn_target)
    except Exception as e:
        raise Exception("Cannot connect to %s:%d, %s" % (host, port, e.message))
    

def send_tcp(log):
    global tcp_socket

    tcp_socket.sendall("%s\n" % log)

def send_tcp_in_bundle(log):
    global tcp_socket
    global bundle_cache
    
    bundle_cache.append("%s\n" % log)
    if len(bundle_cache) >= bundle_size:
        data = ''.join(bundle_cache)
        tcp_socket.sendall(data)
        bundle_cache = []
