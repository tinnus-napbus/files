/-  *files
|%
+$  versioned-state
  $%  state-0
  ==
+$  state-0  [%0 =files]
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
    ?>  ?=(~ `(unit file)`+:(~(fit of files) path.do))
    =/  =file  [pub.do p.mime.do p.q.mime.do]
    :_  this(files (~(put of files) path.do file))
    :~  [%give /did %fact files-did+!>(`did`[%add path.do file])]
        (make-entry:hc path.do pub.do mime.do)
    ==
  ::
      %del
    =/  fis=(list [=path =node])  ~(tap of (~(dip of files) path.do))
    =/  cards=(list card)
      %+  murn  fis
      |=  [=path =node]
      ^-  (unit card)
      ?:  ?=(%dir -.node)  ~
      =?  path  ?=(^ path.do)  [i.path.do path]
      [~ %pass path %arvo %e %set-response (cat 3 '/files' (spat path.do)) ~]
    :_  this(files (~(lop of files) path.do))
    :_  cards
    [%give /did %fact files-did+!>(`did`[%del path.do])]
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
|%
++  make-entry
  |=  [=path pub=? =mime]
  ^-  card
  =/  =cache-entry:eyre
    [pub %payload [200 ['Content-Type' (print-mime p.mime)]~] `q.mime]
  [%pass path %arvo %e %set-response (cat 3 '/files' (spat path)) `cache-entry]
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

