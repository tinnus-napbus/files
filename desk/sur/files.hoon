|%
+$  do
  $%  [%add =way perm=(unit ?) mime=(unit mime)]
      [%del =way]
      [%pub =way perm=(unit ?)]
  ==
+$  did
  $%  ::  [%add =way =file]
      ::  [%del =way]
      ::  [%pub =way =pub]
      [%all files=node]
  ==
+$  file  [=mite size=@ud date=@da aeon=(unit @)]
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
::  print a mime HTTP-style
::
++  print-mime
  |=  =mite
  ^-  @t
  =/  =tape  (spud mite)
  ?~  tape  ''
  ?.  =('/' i.tape)
    (crip tape)
  (crip t.tape)
::  $node engine
::
++  fi
  |_  fis=node
  ::  delete subtree
  ::
  ++  lop
    |=  =way
    ^-  node
    ?:  =(~ way)
      *node
    |-  ^-  node
    ?>  ?=(^ way)
    ?:  ?=(%& -.q.fis)
      fis
    ?~  got=(~(get by p.q.fis) i.way)
      fis
    ?~  t.way
      fis(p.q (~(del by p.q.fis) i.way))
    fis(p.q (~(put by p.q.fis) i.way $(fis u.got, way t.way)))
  ::  delete file (not dir)
  ::
  ++  del
    |=  =way
    ^-  node
    ?:  =(~ way)
      fis
    |-  ^-  node
    ?>  ?=(^ way)
    ?:  ?=(%& -.q.fis)
      fis
    ?~  got=(~(get by p.q.fis) i.way)
      fis
    ?~  t.way
      ?:  ?=(%| -.q.u.got)
        fis
      fis(p.q (~(del by p.q.fis) i.way))
    fis(p.q (~(put by p.q.fis) i.way $(fis u.got, way t.way)))
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
  ::  does node (file or dir) exist?
  ::
  ++  has
    |=  =way
    ^-  ?
    ?=(^ (dip way))
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
  ::  hypothetical permission at location
  ::  or actual if explicit
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
  ::
  ++  pro
    |=  [=way perm=(unit ?)]
    ^-  node
    =/  =pub
     ?^  perm
       [%& u.perm]
     [%| (per (snip way))]
    |-  ^-  node
    ?~  way
      ?:  ?=(%& -.q.fis)
        fis(p pub)
      %=  fis
        p    pub
        p.q  %-  ~(run by p.q.fis)
             |=  fi=node
             ^-  node
             ?:  exp.p.fi
               fi
             ?:  ?=(%& -.q.fi)
               fi(pub.p pub.pub)
             %=  fi
               pub.p  pub.pub
               p.q    (~(run by p.q.fi) |=(f=node ^$(fi f)))
      ==     ==
    ?:  ?=(%& -.q.fis)
      fis
    ?~  kid=(~(get by p.q.fis) i.way)
      fis
    fis(p.q (~(put by p.q.fis) i.way $(way t.way, fis u.kid)))
  ::  add a new file or dir
  ::  if fil is null, it's an empty directory
  ::
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
