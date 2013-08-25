
(defpackage :zmq
  (:use :cl :cffi)
  (:export :version
           :zmq-version-major :zmq-version-minor

           :init :term :with-context
           :ctx-new :ctx-destroy :ctx-set :ctx-get

           :socket-%socket :socket-lock :with-socket-locked
           :socket-fd :socket-events

           :socket :close :with-socket :with-sockets
           :bind :connect
           :unbind :disconnect

           :getsockopt :setsockopt

           :device

           :msg-init :msg-init-size :msg-init-data :msg-close
           :with-msg-init :with-msg-init-size :with-msg-init-data
           :msg-size :msg-data :msg-data-string :msg-data-array
           :msg-copy :msg-move
           :msg-send :msg-recv

           :send :recv
           :with-poll-items
           :poll-item-socket :poll-item-fd
           :poll-items-aref :do-poll-items :poll-item-events-signaled-p
           :poll

           :stopwatch-start :stopwatch-stop :with-stopwatch
           :sleep

           :zmq-error
           :einval-error :enodev-error :eintr-error :efault-error :enomem-error
           :eagain-error :emfile-error :enotsup-error :eprotonosupport-error
           :enobufs-error :enetdown-error :eaddrinuse-error :eaddrnotavail-error
           :econnrefused-error :einprogress-error :enotsock-error
           :efsm-error :enocompatproto-error :eterm-error :emthread-error)
  (:shadow :close :sleep))
