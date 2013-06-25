(include "zmq.h")
#+win32 (include "Winsock2.h")

(in-package :zmq)

(ctype size-t "size_t")

#+win32 (ctype win32-socket "SOCKET")

(constant (max-vsm-size "ZMQ_MAX_VSM_SIZE"))

(constant (zmq-version-major "ZMQ_VERSION_MAJOR"))

(constantenum error-code
              ;; Standard error codes
              ((:einval "EINVAL"))
              ((:enodev "ENODEV"))
              ((:eintr "EINTR"))
              ((:efault "EFAULT"))
              ((:enomem "ENOMEM"))
              ((:eagain "EAGAIN"))
              ((:emfile "EMFILE"))
              ((:enotsup "ENOTSUP"))
              ((:eprotonosupport "EPROTONOSUPPORT"))
              ((:enobufs "ENOBUFS"))
              ((:enetdown "ENETDOWN"))
              ((:eaddrinuse "EADDRINUSE"))
              ((:eaddrnotavail "EADDRNOTAVAIL"))
              ((:econnrefused "ECONNREFUSED"))
              ((:einprogress "EINPROGRESS"))
              ((:enotsock "ENOTSOCK"))
              ;; ZMQ native error codes
              ((:efsm "EFSM"))
              ((:enocompatproto "ENOCOMPATPROTO"))
              ((:eterm "ETERM"))
              ((:emthread "EMTHREAD")))

(bitfield event-types
          ((:pollin "ZMQ_POLLIN"))
          ((:pollout "ZMQ_POLLOUT"))
          ((:pollerr "ZMQ_POLLERR")))

(bitfield recv-options
          ((:noblock "ZMQ_NOBLOCK")))

(bitfield send-options
          ((:noblock "ZMQ_NOBLOCK"))
          ((:sndmore "ZMQ_SNDMORE")))

(constantenum socket-type
              ((:pair "ZMQ_PAIR"))
              ((:pub "ZMQ_PUB"))
              ((:sub "ZMQ_SUB"))
              ((:req "ZMQ_REQ"))
              ((:rep "ZMQ_REP"))
              ((:dealer "ZMQ_DEALER"))
              ((:router "ZMQ_ROUTER"))
              ((:pull "ZMQ_PULL" "ZMQ_UPSTREAM"))
              ((:push "ZMQ_PUSH" "ZMQ_DOWNSTREAM"))
              ((:xpub "ZMQ_XPUB"))
              ((:xsub "ZMQ_XSUB"))
              ((:xreq "ZMQ_XREQ"))
              ((:xrep "ZMQ_XREP")))

(constantenum socket-option
              ((:hwm "ZMQ_HWM") :optional t)
              ((:sndhwm "ZMQ_SNDHWM"))
              ((:rcvhwm "ZMQ_RCVHWM"))
              ((:swap "ZMQ_SWAP") :optional t)
              ((:affinity "ZMQ_AFFINITY"))
              ((:identity "ZMQ_IDENTITY"))
              ((:subscribe "ZMQ_SUBSCRIBE"))
              ((:unsubscribe "ZMQ_UNSUBSCRIBE"))
              ((:rate "ZMQ_RATE"))
              ((:recovery-ivl "ZMQ_RECOVERY_IVL"))
              ((:recovery-ivl-msec "ZMQ_RECOVERY_IVL_MSEC") :optional t)
              ((:mcast-loop "ZMQ_MCAST_LOOP") :optional t)
              ((:sndbuf "ZMQ_SNDBUF"))
              ((:rcvbuf "ZMQ_RCVBUF"))
              ((:rcvmore "ZMQ_RCVMORE"))
              ((:fd "ZMQ_FD"))
              ((:events "ZMQ_EVENTS"))
              ((:type "ZMQ_TYPE"))
              ((:linger "ZMQ_LINGER"))
              ((:reconnect-ivl "ZMQ_RECONNECT_IVL"))
              ((:backlog "ZMQ_BACKLOG"))
              ((:reconnect-ivl-max "ZMQ_RECONNECT_IVL_MAX"))
              ((:maxmsgsize "ZMQ_MAXMSGSIZE"))
              ((:multicast-hops "ZMQ_MULTICAST_HOPS"))
              ((:rcvtimeo "ZMQ_RCVTIMEO"))
              ((:sndtimeo "ZMQ_SNDTIMEO"))
              ((:ipv6 "ZMQ_IPV6") :optional t)
              ((:ipv4only "ZMQ_IPV4ONLY"))
              ((:immediate "ZMQ_IMMEDIATE") :optional t)
              ((:delay-attach-on-connect "ZMQ_DELAY_ATTACH_ON_CONNECT"))
              ((:router-mandatory "ZMQ_ROUTER_MANDATORY"))
              ((:router-raw "ZMQ_ROUTER_RAW") :optional t)
              ((:xpub-verbose "ZMQ_XPUB_VERBOSE"))
              ((:tcp-keepalive "ZMQ_TCP_KEEPALIVE"))
              ((:tcp-keepalive_idle "ZMQ_TCP_KEEPALIVE_IDLE"))
              ((:tcp-keepalive-cnt "ZMQ_TCP_KEEPALIVE_CNT"))
              ((:tcp-keepalive-intvl "ZMQ_TCP_KEEPALIVE_INTVL"))
              ((:tcp-accept-filter "ZMQ_TCP_ACCEPT_FILTER")))

(constantenum device-type
              ((:queue "ZMQ_QUEUE"))
              ((:forwarder "ZMQ_FORWARDER"))
              ((:streamer "ZMQ_STREAMER")))


(cstruct msg "zmq_msg_t")

