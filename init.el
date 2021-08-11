(require 'package)
  (setq package-archives '(("melpa" . "https://melpa.org/packages/")
                           ("melpa-stable" . "https://stable.melpa.org/packages/")
                           ("org" . "https://orgmode.org/elpa/")
                           ("elpa" . "https://elpa.gnu.org/packages/")))

  (package-initialize)
  ;;add-to-list dodaje u listu samo ako varijabla vec nije u njoj! setq dodaje bez obzira na to

  (unless package-archive-contents
    (package-refresh-contents));;proverava da li je package-archive-contents tu, neophodno je proveriti da li postoji na lokalu ili ne, refershuje listu paketa u sustini

  (unless (package-installed-p 'use-package);;-p uvek na kraju znaci predikat(znaci ili true ili nil vrednost)
    (package-install 'use-package));;Ako paket "use-package" nije instaliran, instaliraj ga

(require 'use-package);;ukljucujemo paket
(setq use-package-always-ensure t);;osigurava da paketi koji su neophodni i koji se koriste u datoj emacs konfiguraciji budu preuzeti prilikom pokretanja emacs-a, ukoliko nisu, zato nema potrebe da se navodi :ensure t za svaki fajl
