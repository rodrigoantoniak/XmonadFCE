# XmonadFCE
En este repositorio, se encuentra un archivo de configuración utilizable para incorporar XMonad dentro de Xfce. En muchos casos, se usa XMonad y se agrega el panel de Xfce (en lugar de barras de estado como Polybar o XMobar); pero este archivo funciona con la sesión de Xfce, en vez de XMonad directamente.
## Utilización
Para usar esta configuración, primero debe instalarse XMonad; para ello, debe seguirse el [manual de instalación de XMonad](https://xmonad.org/INSTALL.html) (en lo personal, recomiendo construirlo con `cabal-install`). No es necesario modificar `xinitrc` ni agregar una entrada de escritorio a `xsessions`, con la instalación es más que suficiente.
De ahí, ubicar el archivo de configuración de este repositorio en `~/.config/xmonad/`; así se recompila en XMonad con los ajustes deseados.
Luego, es necesario agregar `xmonad --replace` para que se ejecute al iniciar sesión; para ello, se va a
``` sh
Configuración > Sesión e inicio > Autoarranque de aplicaciones
```
y se añade la aplicación.
Adicionalmente, debe borrarse todas las combinaciones de teclado que vienen incluidas en XFCE; se encuentran en:
``` sh
Configuración > Teclado > Atajos de las aplicaciones
```
Por último, reemplace `librewolf` dentro de xmonad.hs con su navegador Web preferido (si quiere conservar tal, bienvenido sea).
