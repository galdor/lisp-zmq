### PUB-SUB

Let's create a pub-sub pattern where the publisher sends a random number between 0 and 100 (not inclusive), and the subscriber simply receives it.

```common-lisp
(defun publisher ()
  (zmq:with-context (context 1)
    (zmq:with-socket (socket context :pub)
      (zmq:bind socket "tcp://*:8999")
      (loop (let ((data-string (format nil "~d" (random 100))))
              (zmq:with-msg-init-data (message data-string)
                (zmq:send socket message))
              (format t "Publisher sent ~a~%" data-string))))))

(defun subscriber ()
  (zmq:with-context (context 1)
    (zmq:with-socket (socket context :sub)
      (zmq:setsockopt socket :subscribe "")
      (zmq:connect socket "tcp://localhost:8999")
      (loop (zmq:with-msg-init (message)
              (zmq:recv socket message)
              (format t "Subscriber received ~a~%"
                      (zmq:msg-data-string message)))))))
```
A ZMQ context is established using **with-context**. The context resource will be cleaned up when **with-context** exits. **with-context** takes a list of two arguments: a context symbol, and the number of threads in the thread pool.

**with-socket** creates a socket, and closes it once **with-socket** exists.  It accepts a list of two arguments: a socket symbol, and a type of socket.

The subscriber must set the **:subscribe** socket option using **setsockopt**. The other two arguments are a socket, and the filter string (empty string means to get everything).

The publisher initializes and fills a message with data in one shot using **with-msg-init-data**, which takes a list of two arguments: a message symbol, and some data. If data is a string, it's encoded using the default foreign format. On my Allegro CL 9.0 running on Ubuntu it's UTF-8. The subscriber only has to initialize a message, so it uses **with-msg-init**, which takes a list of one argument: a message symbol. Both macros will close the message one they exit.

To extract the data from a message, there are several options. In this case, the subscriber used **msg-data-string**, because it expects a string. However, you could extract an array by using **msg-data-array**, for example.

Sending and receiving is done using **send** and **recv**, which both take two arguments: a socket, and a message.

### PUSH-PULL

You've mastered PUB-SUB, and are ready for the next level. Let's create a push-pull system instead.

```common-lisp
(defun pusher ()
  (zmq:with-context (context 1)
    (zmq:with-socket (socket context :push)
      (zmq:bind socket "tcp://*:9399")
      (loop (let ((data-string (format nil "~d" (random 100))))
              (zmq:with-msg-init-data (msg data-string)
                (zmq:send socket msg))
              (format t "Pusher sending ~a~%" data-string))))))

(defun puller ()
  (zmq:with-context (context 1)
    (zmq:with-socket (socket context :pull)
      (zmq:connect socket "tcp://localhost:9399")
      (loop (zmq:with-msg-init (msg)
              (zmq:recv socket msg)
              (format t "Received ~a~%" (zmq:msg-data-string msg)))))))
```

With the magic which is ZMQ, there aren't many changes that need to be done. The sockets have to be adjusted, but everything else stays the same.

### Polling

Now it's going to get harrier, so get a cup of tea. We're going to setup a poller which polls a subscribe socket, and a pull socket.

```common-lisp
(defun pull-sub ()
  (zmq:with-context (context 1)
    (zmq:with-sockets ((pull-socket context :pull)
                       (sub-socket context :sub))
      (zmq:connect pull-socket "tcp://localhost:9399")
      (zmq:connect sub-socket "tcp://localhost:8999")
      (zmq:setsockopt sub-socket :subscribe "")
      (zmq:with-poll-items (items num-items)
                           ((pull-socket :pollin)
                            (sub-socket :pollin))
        (loop
           (zmq:poll items num-items 2000)
           (cond ((zmq:poll-item-events-signaled-p
                   (zmq:poll-items-aref items 0)
                   :pollin)
                  (zmq:with-msg-init (msg)
                      (zmq:recv pull-socket msg)
                    (format t "Received from pusher: ~a~%"
                            (zmq:msg-data-string msg))))
                 ((zmq:poll-item-events-signaled-p
                   (zmq:poll-items-aref items 1)
                   :pollin)
                  (zmq:with-msg-init (msg)
                      (zmq:recv sub-socket msg)
                    (format t "Received from publisher: ~a~%"
                            (zmq:msg-data-string msg))))))))))
```

Some of the things stay the same. The context and sockets are created the same way. Since one of the sockets is a subscriber socket, its **:subscriber** option needs to be set.

Before polling can occur, you have to configure the necessary data structures which describe what to poll. These data structures are called _poll items_. We use **with-poll-items** to create, and then later automatically clean up, the needed poll items. The first argument is a list which takes two arguments: a symbol that will be bound to our poll items, and another symbol which will be bound to the number of poll items created. The second argument to **with-poll-items** is a list of sockets and events to listen for. Each argument is a list which takes two arguments: a socket, and the event to listen for. In this case, we're pulling and subscribing, so we're only looking for the **:pollin** event.

The actual polling is done by calling **poll**, which takes three arguments: the poll items, number of poll items created, and a timeout in microseconds.  The timeout indicates how long **poll** will wait for to receive an event. If the timeout is set to 2000 microseconds, for example, **poll** will wait at most that much until it exists, even if it didn't receive any events. If the timeout is -1, **poll** will block until some event is received.

Once some event is received, we have to check if a socket received an event we're interested in. This is done by calling **poll-item-events-signaled-p**. It takes two arguments: a poll item, and an event to check for. We get a poll item by calling **poll-items-aref**. It's similar to accessing an array, give the items and an index, and you'll get back the poll item at that position (the order is the same as in **with-poll-item**).

Once we know which socket received a message, it's the same procedure to extract the data like in the previous examples.

### REP-REQ

Let's take a deep breathe and look at something simpler, a req-rep pattern.

```common-lisp
(defun replier ()
  (zmq:with-context (context 1)
    (zmq:with-socket (socket context :rep)
      (zmq:bind socket "tcp://*:8000")
      (loop (zmq:with-msg-init (request)
              (zmq:recv socket request))
            (let ((timestamp (format nil "~d" (get-universal-time))))
              (zmq:with-msg-init-data (reply timestamp)
                (zmq:send socket reply))
              (format t "Sent ~a~%" timestamp))))))

(defun requestor ()
  (zmq:with-context (context 1)
    (zmq:with-socket (socket context :req)
      (zmq:connect socket "tcp://localhost:8000/")
      (loop (zmq:with-msg-init-data (request "")
              (zmq:send socket request))
            (zmq:with-msg-init (reply)
              (zmq:recv socket reply)
              (format t "Received ~a~%" (zmq:msg-data-string reply)))))))
```

Again, the sockets have to be properly created. So one socket is configured to be **:rep** and the other **:req**. Notice that they're both taking turns sending an receiving. That's how the rep-req pattern is built to work.