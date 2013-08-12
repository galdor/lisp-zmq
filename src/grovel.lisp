
(include "zmq.h")
#+windows (include "Winsock2.h")

(in-package :zmq)

(ctype size-t "size_t")

#+windows (ctype win32-socket "SOCKET")

(constant (max-vsm-size "ZMQ_MAX_VSM_SIZE") :optional t) ; 2.x

(constant (zmq-version-major "ZMQ_VERSION_MAJOR"))
(constant (zmq-version-minor "ZMQ_VERSION_MINOR"))
(constant (zmq-version-patch "ZMQ_VERSION_PATCH"))

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

; 3.x
(constantenum context-options
              ((:io-threads "ZMQ_IO_THREADS") :optional t)
              ((:max-sockets "ZMQ_MAX_SOCKETS") :optional t))

(bitfield event-types
          ((:pollin "ZMQ_POLLIN"))
          ((:pollout "ZMQ_POLLOUT"))
          ((:pollerr "ZMQ_POLLERR")))

(bitfield recv-options
          ((:noblock "ZMQ_NOBLOCK" "ZMQ_DONTWAIT") :optional t)    ; 2.x
          ((:dontwait "ZMQ_DONTWAIT" "ZMQ_NOBLOCK") :optional t))  ; 3.x

(bitfield send-options
          ((:noblock  "ZMQ_NOBLOCK" "ZMQ_DONTWAIT") :optional t)  ; 2.x
          ((:dontwait "ZMQ_DONTWAIT" "ZMQ_NOBLOCK") :optional t)  ; 3.x
          ((:sndmore "ZMQ_SNDMORE")))

(constantenum socket-type
              ((:pair "ZMQ_PAIR"))
              ((:pub "ZMQ_PUB"))
              ((:sub "ZMQ_SUB"))
              ((:req "ZMQ_REQ"))
              ((:rep "ZMQ_REP"))
              ((:dealer "ZMQ_DEALER"))
              ((:router "ZMQ_ROUTER"))
              ((:pull "ZMQ_PULL"))
              ((:push "ZMQ_PUSH"))
              ((:xpub "ZMQ_XPUB"))
              ((:xsub "ZMQ_XSUB"))
              ((:xreq "ZMQ_XREQ"))
              ((:xrep "ZMQ_XREP"))
              ((:upstream "ZMQ_UPSTREAM") :optional t)       ; 2.x
              ((:downstream "ZMQ_DOWNSTREAM") :optional t))  ; 2.x

(constantenum socket-option
              ((:hwm "ZMQ_HWM") :optional t)                                    ; 2.x
              ((:swap "ZMQ_SWAP") :optional t)                                  ; 2.x
              ((:affinity "ZMQ_AFFINITY"))
              ((:identity "ZMQ_IDENTITY"))
              ((:subscribe "ZMQ_SUBSCRIBE"))
              ((:unsubscribe "ZMQ_UNSUBSCRIBE"))
              ((:rate "ZMQ_RATE"))
              ((:recovery-ivl "ZMQ_RECOVERY_IVL"))
              ((:recovery-ivl-msec "ZMQ_RECOVERY_IVL_MSEC") :optional t)        ; 2.x
              ((:mcast-loop "ZMQ_MCAST_LOOP") :optional t)                      ; 2.x
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
              ((:maxmsgsize "ZMQ_MAXMSGSIZE") :optional t)                      ; 3.x
              ((:sndhwm "ZMQ_SNDHWM") :optional t)                              ; 3.x
              ((:rcvhwm "ZMQ_RCVHWM") :optional t)                              ; 3.x
              ((:multicast-hops "ZMQ_MULTICAST_HOPS") :optional t)              ; 3.x
              ((:rcvtimeo "ZMQ_RCVTIMEO"))
              ((:sndtimeo "ZMQ_SNDTIMEO"))
              ((:ipv4only "ZMQ_IPV4ONLY") :optional t)                          ; 3.x
              ((:last-endpoint "ZMQ_LAST_ENDPOINT") :optional t)                ; 3.x
              ((:router-mandatory "ZMQ_ROUTER_MANDATORY") :optional t)          ; 3.x
              ((:tcp-keepalive "ZMQ_TCP_KEEPALIVE") :optional t)                ; 3.x
              ((:tcp-keepalive_idle "ZMQ_TCP_KEEPALIVE_IDLE") :optional t)      ; 3.x
              ((:tcp-keepalive-cnt "ZMQ_TCP_KEEPALIVE_CNT") :optional t)        ; 3.x
              ((:tcp-keepalive-intvl "ZMQ_TCP_KEEPALIVE_INTVL") :optional t)    ; 3.x
              ((:tcp-accept-filter "ZMQ_TCP_ACCEPT_FILTER") :optional t)        ; 3.x
              ((:delay-attach-on-connect "ZMQ_DELAY_ATTACH_ON_CONNECT") :optional t) ; 3.x
              ((:xpub-verbose "ZMQ_XPUB_VERBOSE") :optional t))                 ; 3.x

(constantenum device-type
              ((:queue "ZMQ_QUEUE"))
              ((:forwarder "ZMQ_FORWARDER"))
              ((:streamer "ZMQ_STREAMER")))


(cstruct msg "zmq_msg_t")

(cstruct pollitem "zmq_pollitem_t"
         (socket "socket" :type :pointer)
         (fd "fd" :type :auto)
         (events "events" :type :short)
         (revents "revents" :type :short))
