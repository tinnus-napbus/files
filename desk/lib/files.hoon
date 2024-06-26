/-  *files
|%
++  de-json
  |=  jon=json
  ^-  do
  =,  dejs:format
  %.  jon
  %-  of
  :~  [%dir (ot way+(ar so) perm+(mu bo) ~)]
      [%del (ot way+(ar so) ~)]
      [%pub (ot way+(ar so) perm+(mu bo) ~)]
      [%mov (ot from+(ar so) dest+(ar so) ~)]
      [%cpy (ot from+(ar so) dest+(ar so) ~)]
  ==
::
++  en-json
  |=  di=did
  ^-  json
  ?>  ?=(%all -.di)
  =,  enjs:format
  =|  nam=@t
  =|  pax=way
  |-  ^-  json
  ?:  ?=(%& -.q.files.di)
    %+  frond  %fil
    %-  pairs
    :~  name+s+nam
        path+a+(turn (flop pax) |=(n=@t `json`s+n))
        perm+(pairs exp+b+exp.p.files.di pub+b+pub.p.files.di ~)
        mime+s+(print-mime mite.p.q.files.di)
        size+(numb size.p.q.files.di)
        date+(time time.p.q.files.di)
    ==
  %+  frond  %dir
  %-  pairs
  :~  name+s+nam
      path+a+(turn (flop pax) |=(n=@t `json`s+n))
      perm+(pairs exp+b+exp.p.files.di pub+b+pub.p.files.di ~)
      :+  %contents  %a
      ^-  (list json)
      %+  turn  ~(tap by p.q.files.di)
      |=  (pair @t node)
      ^-  json
      ^$(nam p, pax [p pax], files.di q)
  ==
--
