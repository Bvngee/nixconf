import material_color_utilities_python as monet

img = monet.Image.open("/home/jack/Downloads/alena-aenami-budapest.jpg")

basewidth = 64
wpercent = (basewidth/float(img.size[0]))
hsize = int((float(img.size[1])*float(wpercent)))
img = img.resize((basewidth,hsize), monet.Image.Resampling.LANCZOS)
theme = monet.themeFromImage(img)
dark_scheme = theme["schemes"]["dark"].props
final = {}
for k, v in dark_scheme.items():
    final[k] = monet.hexFromArgb(v)

__import__('pprint').pprint(final)
