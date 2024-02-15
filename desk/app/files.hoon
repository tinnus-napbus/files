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
      `[p.u.mime.do p.q.u.mime.do now.bowl]
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
      %pub  !!
  ==
::
++  on-watch  on-watch:def
++  on-arvo   on-arvo:def
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

