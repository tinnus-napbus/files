|%
+$  do
  $%  [%add =path perm=(unit ?) =mime]
      [%del =path]
      [%pub =path perm=(unit ?)]
  ==
+$  did
  $%  [%add =path =file]
      [%del =path]
      [%pub =path =pub]
      [%all files=node]
  ==
+$  file  [=mite size=@ud date=@da]
::  public or private, where exp is explicit/implicit
::
+$  pub  [exp=_| pub=_|]
::  path to file or directory
::
+$  way  (list @t)
::  file structure with permissions. Like an axal but characters in
::  paths aren't limited to @tas, empty folders are allowed, permissions
::  are tracked, and files can't simultaneously be directories.
::
+$  node
  $~  [p=[%| p=|] [%| p=~]]
  $:  p=pub
      $=  q
      $%  [%| p=(map @t node)]
          [%& p=file]
  ==  ==
::  $node engine
::
++  fi
  |_  fis=node
  ::  get unitised subtree
  ::
  ++  dip
    |=  =way
    ^-  (unit node)
    ?~  way  `fis
    ?:  ?=(%& -.q.fis)  ~
    =/  kid  (~(get by p.q.fis) i.way)
    ?~  kid  ~
    $(fis u.kid, way t.way)
  ::  get unitised file at path
  ::
  ++  get
    |=  =way
    ^-  (unit file)
    ?~  got=(dip way)
      ~
    ?:  ?=(%| -.q.u.got)
      ~
    (some p.q.u.got)
  ::  get file at path or crash
  ::
  ++  got
    |=  =way
    ^-  file
    (need (get way))
  ::  calculate inherited permission at location
  ::
  ++  per
    |=  =way
    ^-  ?
    =/  perm=?  pub.p.fis
    |-
    ?~  way
      perm
    ?:  ?=(%& -.q.fis)
      pub.p.fis
    =/  kid  (~(get by p.q.fis) i.way)
    ?~  kid
      perm
    $(way t.way, fis u.kid, perm pub.p.u.kid)
  ::  set and propagate permissions
  ::  perm is either explicit or ~ for implicit
  ::
  ++  pro  ~
  ::  add a new file
  ::  if fil is null, it's an empty directory
  ++  put
    |=  [=way perm=(unit ?) fil=(unit file)]
    ^-  (unit node)
    ?:  =(~ way)
      ~
    =/  nam  (rear way)
    =/  pat  (snip way)
    |-  ^-  (unit node)
    ?:  ?=(%& -.q.fis)
      ~
    ?~  pat
      ?:  (~(has by p.q.fis) nam)
        ~
      %-  some
      %=  fis
        p.q  %+  ~(put by p.q.fis)  nam
             :-  ?^(perm [& u.perm] [| pub.p.fis])
             ?~(fil [%| ~] [%& u.fil])
      ==
    ?~  got=(~(get by p.q.fis) i.pat)
      ~
    =/  nu  $(pat t.pat, fis u.got)
    ?~  nu
      ~
    `fis(p.q (~(put by p.q.fis) i.pat u.nu))
  ::  get list of files (not directories) below path
  ::
  ++  key
    |=  w=way
    ^-  (list way)
    ?~  kid=(dip w)
      ~
    %+  turn
      =|  pax=way
      =|  out=(list way)
      |-  ^-  (list way)
      ?:  ?=(%& -.q.u.kid)  [pax out]
      =/  dir  ~(tap by p.q.u.kid)
      |-  ^-   (list way)
      ?~  dir  out
      %=  $
        dir  t.dir
        out  ^$(pax (weld pax /[p.i.dir]), u.kid q.i.dir)
      ==
    |=(=way (weld w way))
  --
--
