/-  *files
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
  ?-    do
      %add
    =/  fil=(unit file)
      ?~  mime.do  ~
      `[p.u.mime.do p.q.u.mime.do now.bowl]
    =.  files  (need (~(put fi files) way.do perm.do fil))
    :_  this
    :-  [%give /did %fact files-did+!>(`did`[%all files])]
    ?~  fil  ~
    ~[(make-entry:hc path.do pub.do mime.do)]
  ::
      %del
    =/  ways  (~(key by fi) way.do)
    =/  cards=(list card)
      (turn ways delete-entry:hc)
    =.  files  (~(lop fi files) way.d)
    :_  this
    :_  cards
    [%give /did %fact files-did+!>(`did`[%all files])]
  ::
      %pub
    =/  fis=(list [=path =node])  ~(tap of (~(dip of files) path.do))
    

  ==
::
++  on-watch
  |=  =path
  ^-  (quip card _this)
::
++  on-arvo
  |=  [=wire sign=sign-arvo]
  ^-  (quip card _this)
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
++  make-entry
  |=  [=way pub=? =mime]
  ^-  card
  =/  =cache-entry:eyre
    [pub %payload [200 ['Content-Type' (print-mime p.mime)]~] `q.mime]
  [%pass path %arvo %e %set-response (make-url way) `cache-entry]
::
++  delete-entry
  |=  =way
  ^-  card
  [%pass path %arvo %e %set-response (make-url way) ~]
::
++  print-mime
  |=  =mite
  ^-  @t
  =/  =tape  (spud mite)
  ?~  tape  ''
  ?.  =('/' i.tape)
    (crip tape)
  (crip t.tape)
--

