/-  *files
/+  dbug, default-agent
|%
+$  versioned-state
  $%  state-0
  ==
+$  state-0  [%0 files=node =blobs]
+$  card  card:agent:gall
--
::
%-  agent:dbug
=|  state-0
=*  state  -
=<
^-  agent:gall
|_  =bowl:gall
+*  this  .
    def   ~(. (default-agent this %.n) bowl)
    hc    ~(. +> bowl)
++  on-init
  ^-  (quip card _this)
  :_  this
  [%pass /bind %arvo %e %connect `/files-upload %files]~
::
++  on-save  !>(state)
::
++  on-load
  |=  old-vase=vase
  ^-  (quip card _this)
  `this(state !<(state-0 old-vase))
::
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  ?>  =(our.bowl src.bowl)
  ?:  ?=(%handle-http-request mark)
    =/  req  !<  (pair @ta inbound-request:eyre)  vase
    ?.  =('POST' method.request.q.req)
      :_  this
      (response:hc p.req 405 ['Allow' 'POST']~ 'Method not allowed')
    =/  =way  (decode-url:hc '/files-upload/' url.request.q.req)
    ?~  body.request.q.req
      :_  this
      (response:hc p.req 400 ~ 'Body empty')
    =/  =mite
      %-  parse-mime:hc
      %+  fall
        (get-header:http 'content-type' header-list.request.q.req)
      'application/octet-stream'
    =/  =octs  u.body.request.q.req
    =/  data=@  +.octs
    =/  =ftyp  [mite -.octs]
    =/  fil=file  [ftyp now.bowl]
    =/  fis=(unit node)  (~(put fi files) way ~ `fil)
    ?~  fis
      :_  this
      %:  response:hc
        p.req  422  ~
        'Cannot add file at location'
      ==
    =/  per=?  (~(per fi u.fis) way)
    :_  this(files u.fis, blobs (~(put by blobs) (make-url way) data))
    :*  [%give %fact ~[/did] files-did+!>(`did`[%all u.fis])]
        (make-entry:hc way per ftyp data)
        %:  response:hc
          p.req  201
          ['Location' (make-url:hc way)]~
          'Success'
        ==
    ==
  ?.  ?=(%files-do mark)  (on-poke:def mark vase)
  =+  !<(=do vase)
  ?-    -.do
      %dir
    =.  files  (need (~(put fi files) way.do perm.do ~))
    :_  this
    [%give %fact ~[/did] files-did+!>(`did`[%all files])]~
  ::
      %del
    =/  ways  (~(key fi files) way.do)
    =/  cards=(list card)
      (turn ways delete-entry:hc)
    =.  files  (~(lop fi files) way.do)
    :_  %=  this
          blobs
          %+  roll
            ways
          |=  [=way b=_blobs]
            (~(del by b) (make-url way))
        ==
    :_  cards
    [%give %fact ~[/did] files-did+!>(`did`[%all files])]
  ::
      %pub
    =.  files  (~(pro fi files) way.do perm.do)
    =/  cards=(list card)
      %+  turn  (~(key fi files) way.do)
      |=  =way
      ^-  card
      =/  =file  (~(got fi files) way)
      =/  per=?  (~(per fi files) way)
      (make-entry:hc way per ftyp.file (~(got by blobs.this) (make-url way)))
    :_  this
    :_  cards
    [%give %fact ~[/did] files-did+!>(`did`[%all files])]
  ::
      %mov
    =/  froms=(list way)
      (~(key fi files) from.do)
    =/  dests=(list way)
      %+  turn
        froms
      |=  w=way
      =/  rem=way
        (oust [0 (lent from.do)] w)
      (weld rem dest.do)
    =/  ways=(list (pair way way))
      %+  spun
      dests
      |=([dest=way i=@] [[(snag i froms) dest] +(i)])
    =/  deleted=(list card)
      (turn froms delete-entry:hc)
    =.  files  (need (~(mov fi files) from.do dest.do))
    =/  added=(list card)
      %+  turn  ways
      |=  [from=way dest=way]
      ^-  card
      =/  =file  (~(got fi files) dest)
      =/  per=?  (~(per fi files) dest)
      (make-entry:hc dest per ftyp.file (~(got by blobs.this) (make-url from)))
    :_  %=  this
          blobs
          %+  roll
            ways
          |=  [[from=way dest=way] b=_blobs]
            %-  %~  del
                  by
                %+  ~(put by b)
                  (make-url dest)
                (~(got by b) (make-url from))
            (make-url from)
        ==
    :_  (weld deleted added)
    [%give %fact ~[/did] files-did+!>(`did`[%all files])]
  ::
      %cpy
    =.  files  (need (~(cop fi files) from.do dest.do))
    =/  froms=(list way)
      (~(key fi files) from.do)
    =/  dests=(list way)
      %+  turn
        froms
      |=  w=way
      =/  rem=way
        (oust [0 (lent from.do)] w)
      (weld rem dest.do)
    =/  ways=(list (pair way way))
      %+  spun
      dests
      |=([dest=way i=@] [[(snag i froms) dest] +(i)])
    =/  cards=(list card)
      %+  turn  ways
      |=  [from=way dest=way]
      ^-  card
      =/  =file  (~(got fi files) dest)
      =/  per=?  (~(per fi files) dest)
      %:  make-entry:hc
        dest
        per
        ftyp.file
        (~(got by blobs.this) (make-url from))
      ==
    :_  %=  this
          blobs
        %+  roll
          ways
        |=  [[from=way dest=way] b=_blobs]
          %+  ~(put by b)
            (make-url dest)
          (~(got by b) (make-url from))
        ==
    :_  cards
    [%give %fact ~[/did] files-did+!>(`did`[%all files])]
  ==
::
++  on-arvo
  |=  [=wire sign=sign-arvo]
  ^-  (quip card _this)
  ?.  ?=([%bind ~] wire)
    (on-arvo:def wire sign)
  ?.  ?=([%eyre %bound *] sign)
    (on-arvo:def wire sign)
  ~?  !accepted.sign
    %eyre-rejected-files-binding
  `this
::
++  on-watch
  |=  =path
  ^-  (quip card _this)
  ?>  =(src.bowl our.bowl)
  ?+    path  (on-watch:def path)
      [%http-response *]
    `this
  ::
      [%did ~]
    :_  this
    [%give %fact ~ files-did+!>(`did`[%all files])]~
  ==
::
++  on-peek
  |=  =path
  ^-  (unit (unit cage))
  ?+    path  (on-peek:def path)
      [%x %dbug %state ~]
    :^  ~  ~  %noun
    !>
    %=  state
        files
      |-  ^-  node
      ?:  ?=(%& -.q.files)
        files
      files(p.q (~(run by p.q.files) |=(=node ^$(files node))))
    ==
  ==
::
++  on-agent  on-agent:def
++  on-leave  on-leave:def
++  on-fail   on-fail:def
--
::
|_  =bowl:gall
++  parse-mime
  |=  txt=@t
  |^  ^-  mite
  %-  fall
  :_  /application/octet-stream
  %+  rust  (cass (trip txt))
  ;~(plug part (ifix [fas (star next)] part) (easy ~))
  ++  part  (cook crip (star ;~(pose aln hep dot)))
  --
::
++  filename
  |=  =way
  ^-  tape
  (en-urlt:html (trip (rear way)))
::
++  make-url
  |=  =way
  ^-  @t
  %+  rap  3
  %+  join  '/'
  :-  '/files'
  %+  turn  way
  |=  =cord
  (crip (en-urlt:html (trip cord)))
::
++  decode-url
  |=  [prefix=@t url=@t]
  ^-  way
  %+  rash  url
  %+  cook
    |=  ents=(list tape)
    ^-  way
    %+  turn  ents
    |=  t=tape
    (crip (need (de-urlt:html t)))
  ;~(pfix (jest prefix) (more fas (star ;~(less fas next))))
::
++  path-to-way
  |=  =path
  ^-  way
  (turn path (cury slav %t))
::
++  way-to-path
|=  way=(list @t)
^-  path
(turn way (cury scot %t))
::
++  make-entry
  |=  [=way pub=? =ftyp data=@]
  ^-  card
  =/  hed=header-list:http
    :~  ['Content-Type' (print-mime p.ftyp)]
        ['Content-Disposition' (crip "inline;filename=\"{(filename way)}\"")]
    ==
  =/  =cache-entry:eyre
    [!pub %payload [200 hed] `[q.ftyp data]]
  [%pass (way-to-path way) %arvo %e %set-response (make-url way) `cache-entry]
::
++  delete-entry
  |=  =way
  ^-  card
  [%pass (way-to-path way) %arvo %e %set-response (make-url way) ~]
::
++  give-response
  |=  [id=@ta hed=response-header:http dat=(unit octs)]
  ^-  (list card)
  :~  [%give %fact ~[/http-response/[id]] %http-response-header !>(hed)]
      [%give %fact ~[/http-response/[id]] %http-response-data !>(dat)]
      [%give %kick ~[/http-response/[id]] ~]
  ==
::
++  response
  |=  [id=@ta code=@ud hed=header-list:http msg=@t]
  ^-  (list card)
  %^    give-response
      id
    :-  code
    :+  ['Content-Type' 'text/plain']
      ['Content-Length' (crip (a-co:co (met 3 msg)))]
    hed
  (some (as-octs:mimes:html msg))
--
