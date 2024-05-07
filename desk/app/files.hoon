/-  *files
/+  dbug, default-agent
|%
+$  versioned-state
  $%  state-0
  ==
+$  state-0  [%0 dex=node dat=data]
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
    =/  hash=@uvH  (shay octs)
    =/  fil=file  [mite now.bowl p.octs & hash]
    =/  fis=(unit node)  (~(put fi dex) way ~ `fil)
    ?~  fis
      :_  this
      %:  response:hc
        p.req  422  ~
        'Cannot add file at location'
      ==
    =/  per=?  (~(per fi u.fis) way)
    =.  dat
      ?~  got=(~(get by dat) hash)
        (~(put by dat) hash (~(put in *(set ^way)) way) octs)
      (~(put by dat) hash u.got(refs (~(put in refs.u.got) way)))
    :_  this(dex u.fis)
    :*  [%give %fact ~[/did] files-did+!>(`did`[%all u.fis])]
        (make-entry:hc way per mite octs)
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
    =.  dex  (need (~(put fi dex) way.do perm.do ~))
    :_  this
    [%give %fact ~[/did] files-did+!>(`did`[%all dex])]~
  ::
      %del
    =/  ways  (~(key fi dex) way.do)
    =.  dat
      |-
      ?~  ways
        dat
      ?~  fu=(~(get fi dex) i.ways)
        $(ways t.ways)
      ?.  have.u.fu  $(ways t.ways)
      ?~  du=(~(get by dat) hash.u.fu)
        $(ways t.ways)
      =.  refs.u.du  (~(del in refs.u.du) i.ways)
      ?~  refs.u.du
        $(ways t.ways, dat (~(del by dat) hash.u.fu))
      $(ways t.ways, dat (~(put by dat) hash.u.fu u.du))
    =/  cards=(list card)
      (turn ways delete-entry:hc)
    =.  dex  (~(lop fi dex) way.do)
    :_  this
    :_  cards
    [%give %fact ~[/did] files-did+!>(`did`[%all dex])]
  ::
      %pub
    =.  dex  (~(pro fi dex) way.do perm.do)
    ::  generate new cache entry cards
    =/  cards=(list card)
      %+  turn  (~(key fi dex) way.do)
      |=  =way
      ^-  card
      =/  =file  (~(got fi dex) way)
      =/  per=?  (~(per fi dex) way)
      =/  =datum  (~(got by dat) hash.file)
      (make-entry:hc way per mite.file octs.datum)
    :_  this
    :_  cards
    [%give %fact ~[/did] files-did+!>(`did`[%all dex])]
  ::
      %mov
    =/  froms  (~(key fi dex) from.do)
    ::  produce list of new/old paths and their hashes
    =/  change=(list [from=way to=way hash=@uvH])
      =/  len  (lent dest.do)
      %+  turn  froms
      |=  =way
      :+  way
        (weld dest.do (slag len way))
      hash:(~(got fi dex) way)
    =.  dex  (need (~(mov fi dex) from.do dest.do))
    =/  deleted=(list card)  (turn froms delete-entry:hc)
    ::  swap path references in data map
    =.  dat
      |-
      ?~  change
        dat
      ?~  got=(~(get by dat) hash.i.change)
        $(change t.change)
      =.  refs.u.got  (~(del in refs.u.got) from.i.change)
      =.  refs.u.got  (~(put in refs.u.got) to.i.change)
      %=  $
        change  t.change
        dat  (~(put by dat) hash.i.change u.got)
      ==
    =/  added=(list card)
      %+  turn  (~(key fi dex) dest.do)
      |=  =way
      ^-  card
      =/  =file  (~(got fi dex) way)
      =/  per=?  (~(per fi dex) way)
      =/  =datum  (~(got by dat) hash.file)
      (make-entry:hc way per mite.file octs.datum)
    :_  this
    :_  (weld deleted added)
    [%give %fact ~[/did] files-did+!>(`did`[%all dex])]
  ::
      %cpy
    =.  dex  (need (~(cop fi dex) from.do dest.do))
    =/  tos  (~(key fi dex) dest.do)
    ::  generate list of new paths and their hashes
    =/  change=(list [to=way hash=@uvH])
      %+  turn  tos
      |=  =way
      :-  way
      hash:(~(got fi dex) way)
    ::  add new paths to data reference sets
    =.  dat
      |-
      ?~  change
        dat
      ?~  got=(~(get by dat) hash.i.change)
        $(change t.change)
      =.  refs.u.got  (~(put in refs.u.got) to.i.change)
      %=  $
        change  t.change
        dat  (~(put by dat) hash.i.change u.got)
      ==
    ::  new cache entries for copies
    =/  cards=(list card)
      %+  turn  tos
      |=  =way
      ^-  card
      =/  =file  (~(got fi dex) way)
      =/  per=?  (~(per fi dex) way)
      =/  =datum  (~(got by dat) hash.file)
      (make-entry:hc way per mite.file octs.datum)
    :_  this
    :_  cards
    [%give %fact ~[/did] files-did+!>(`did`[%all dex])]
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
    [%give %fact ~ files-did+!>(`did`[%all dex])]~
  ==
::
++  on-peek
  |=  =path
  ^-  (unit (unit cage))
  ?+    path  (on-peek:def path)
      [%x %dbug %state ~]
    :^  ~  ~  %noun
    !>(state(dat (~(run by dat) |=(=datum datum(q.octs 1.337)))))
  ==
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
  |=  [=way pub=? =mime]
  ^-  card
  =/  hed=header-list:http
    :~  ['Content-Type' (print-mime p.mime)]
        ['Content-Disposition' (crip "inline;filename=\"{(filename way)}\"")]
    ==
  =/  =cache-entry:eyre
    [!pub %payload [200 hed] `q.mime]
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

