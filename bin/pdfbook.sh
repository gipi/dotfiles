pdfjam --landscape --signature 16 --vanilla --paper a3paper --preamble '\usepackage{everyshi}
\makeatletter
\EveryShipout{\ifodd\c@page\pdfpageattr{/Rotate 180}\fi}
\makeatother
' -- $1 -
