gcc -O2 ppm2bpm.c -o ppm2bpm
chmod +x ./ppm2bpm
ffmpeg -i $1 -filter:v scale=-1:768 temp.ppm
./ppm2bpm temp.ppm $2
rm temp.ppm
