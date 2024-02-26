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
  ?.  ?=(%files-do mark)  (on-poke:def mark vase)
  =+  !<(=do vase)
  ?-    -.do
      %add
    =/  fil=(unit file)
      ?~  mime.do  ~
      `[p.u.mime.do p.q.u.mime.do now.bowl ~]
    =.  files  (need (~(put fi files) way.do perm.do fil))
    =/  per=?  (~(per fi files) way.do)
    :_  this
    :-  [%give %fact ~[/did] files-did+!>(`did`[%all files])]
    ?~  mime.do  ~
    ~[(make-entry:hc way.do per u.mime.do)]
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
      (make-entry:hc way per mim)
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
  =.  files  (~(del fi files) way)
  =.  files  (need (~(put fi files) way ~ u.got(aeon `rev)))
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
--

