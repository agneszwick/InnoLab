
- Daten: https://gdz.bkg.bund.de/index.php/default/verwaltungsgebiete-1-250-000-stand-31-12-vg250-31-12.html
- Landkreisebene: Kreis VG250_KRS.SHP
- GF: Geofaktor
	- Werteübersicht:
		- 1 = ohne Struktur Gewässer
		- 2 = mit Struktur Gewässer
		- 3 = ohne Struktur Land
		- 4 = mit Struktur Land
	
	- Die Gebiete, in denen unterhalb der Landesebene keine weiteren Ebenen vorhanden sind, erhalten die Angabe „ohne Struktur“. Die Angabe Gewässer bezieht sich auf die Nord- und Ostsee sowie den Bodensee. Verwaltungseinheiten, deren Gebiet sich auch über die Nord- oder Ostsee bzw. den Bodensee erstreckt, sind an der Küste getrennt. Eine Unterscheidung der beiden Teile der betroffenen Verwaltungseinheiten ist über das Attribut GF (Geofaktor) möglich. Die Teilfläche auf den genannten Gewässern besitzt den GF-Wert 2. Dagegen besitz die Landteilflächen den GF-Wert 4.
	- 
- SDV_ARS: Sitz der Verwaltung (Amtl. Regionalschlüssel) dieser ist identisch bei kreisfreien Städten und den zugehörigen Landkreisen --> polygone mit gleicher SDV_ARS zusammenfügen 
- 