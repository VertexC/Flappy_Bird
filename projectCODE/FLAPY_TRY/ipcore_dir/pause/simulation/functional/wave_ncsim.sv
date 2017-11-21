

 
 
 

 



window new WaveWindow  -name  "Waves for BMG Example Design"
waveform  using  "Waves for BMG Example Design"

      waveform add -signals /pause_tb/status
      waveform add -signals /pause_tb/pause_synth_inst/bmg_port/CLKA
      waveform add -signals /pause_tb/pause_synth_inst/bmg_port/ADDRA
      waveform add -signals /pause_tb/pause_synth_inst/bmg_port/DOUTA

console submit -using simulator -wait no "run"
