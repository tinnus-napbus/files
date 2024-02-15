/-  *files
|%
++  de-json
  ^-  do
  =,  dejs:format
  %-  of
  :~  [%del (ot way+(ar so) ~)]
      [%pub (ot way+(ar so) perm+(mu bo) ~)]
  ==
::
++  en-json
  |=  di=did
  ^-  json
  ?>  ?=(%all -.di)
  =,  dejs:format
  =|  nam=@t
  |-  ^-  json
  ?:  ?=(%& -.q.files.di)
    %+  frond  %fil
    %-  pairs
    :~  name+s+nam
        perm+(pairs exp+b+exp.p.files.di pub+b+pub.p.files.di ~)
        mime+s+(print-mime mite.p.q.files.di)
        size+(numb size.p.q.files.di)
        date+(time date.p.q.files.di)
    ==
  %+  frond  %dir
  %-  pairs
  :~  name+s+nam
      perm+(pairs exp+b+exp.p.files.di pub+b+pub.p.files.di ~)
      :+  %dirs  %a
      ^-  (list json)
      %+  turn  ~(tap by p.q.files.di)
      |=  (pair @t node)
      ^-  json
      ^$(nam p.i.fis, files.di q.i.fis)
  ==
--
