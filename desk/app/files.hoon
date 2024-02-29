/-  *files
/+  dbug, default-agent
|%
+$  versioned-state
  $%  state-0
  ==
+$  state-0  [%0 files=node]
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
++  on-init  on-init:def
++  on-save  !>(state)
++  on-load
  |=  old-vase=vase
  ^-  (quip card _this)
  [~ this(state !<(state-0 old-vase))]
::
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  ?>  =(our.bowl src.bowl)
  ?:  ?=(%handle-http-request mark)
    =/  req  !<  (pair @ta inbound-request:eyre)  vase
    ?.  =('POST' method.request.q.req)
      :_  this
      (response:hc p.req 405 ['Allow' 'POST']~ '405 Method not allowed')
    =/  =way  (decode-url:hc '/files-upload/' url.request.q.req)
    ?~  body.request.q.req
      :_  this
      (response:hc p.req 400 ~ '400 Bad Request: Body empty>')
    =/  =mite
      %-  parse-mime:hc
      %+  fall
        (get-header:http 'content-type' header-list.request.q.req)
      'application/octet-stream'
    =/  fil=file
      [mite p.u.body.request.q.req now.bowl ~]
    =/  fis=(unit node)  (~(put fi files) way ~ `fil)
    ?~  fis
      :_  this
      %:  response:hc
        p.req  422  ~
        '422 Unprocessable entity: Cannot add file at location'
      ==
    =/  per=?  (~(per fi u.fis) way)
    :_  this(files u.fis)
    :*  [%give %fact ~[/did] files-did+!>(`did`[%all u.fis])]
        (make-entry:hc way per mite u.body.request.q.req)
        %:  response:hc
          p.req  201
          ['Location' (make-url:hc way)]~
          '201 Created: Success'
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
    :_  this
    :_  cards
    [%give %fact ~[/did] files-did+!>(`did`[%all files])]
  ::
      %pub
    =.  files  (~(pro fi files) way.do perm.do)
    =/  ways  (~(key fi files) way.do)
    =/  cards=(list card)
      %+  murn  ways
      |=  =way
      ^-  (unit card)
      =/  =file  (~(got fi files) way)
      ?~  aeon.file
        ~
      =+  .^  ent=cache-entry:eyre
            %e
            (scot %p our.bowl)
            %$
            (scot %da now.bowl)
            %cache
            (scot %ud u.aeon.file)
            (scot %t (make-url:hc way))
          ==
      =/  per=?  (~(per fi files) way)
      ?>  ?=(%payload -.body.ent)
      ?~  data.simple-payload.body.ent
        ~
      =/  mim=mime
        :-  mite.file
        u.data.simple-payload.body.ent
      `(make-entry:hc way per mim)
    :_  this
    :_  cards
    [%give %fact ~[/did] files-did+!>(`did`[%all files])]
  ==
::
++  on-arvo
  |=  [=wire sign=sign-arvo]
  ^-  (quip card _this)
  ?.  ?=([%eyre %grow %cache @ @ ~] sign)
    (on-arvo:def wire sign)
  =/  rev=@   (slav %ud i.t.path.sign)
  =/  =way  (path-to-way:hc wire)
  ?~  got=(~(get fi files) way)
    `this
  =/  per=(unit ?)
    =/  kid=node  (need (~(dip fi files) way))
    ?.  exp.p.kid
      ~
    `pub.p.kid
  =.  files  (~(del fi files) way)
  =.  files  (need (~(put fi files) way per `u.got(aeon `rev)))
  `this
::
++  on-watch
  |=  =path
  ^-  (quip card _this)
  ?>  =(src.bowl our.bowl)
  :_  this
  [%give %fact ~ files-did+!>(`did`[%all files])]~
::
++  on-peek   on-peek:def
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
  |=  =way
  ^-  path
  (turn way (cury scot %t))
::
++  make-entry
  |=  [=way pub=? =mime]
  ^-  card
  =/  =cache-entry:eyre
    [pub %payload [200 ['Content-Type' (print-mime p.mime)]~] `q.mime]
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

