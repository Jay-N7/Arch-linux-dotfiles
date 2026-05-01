# load settings from autoconfig.yml (if you want)
config.load_autoconfig()  # or config.load_autoconfig(False)
#from config import load_autoconfig
#load_autoconfig()
# Toggle tabs + statusbar with ,x
config.bind(',x', 'config-cycle statusbar.show always never ;; config-cycle tabs.show always never')
c.colors.webpage.bg = 'rgba(0,0,0,0)'
