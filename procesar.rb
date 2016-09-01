require 'pry'
require 'csv'

def mean(array)
  array.inject(:+).to_f / array.count.to_f
end

def median(array, already_sorted=false)
  return nil if array.empty?
  array = array.sort unless already_sorted
  m_pos = array.size / 2
  return array.size % 2 == 1 ? array[m_pos] : mean(array[m_pos-1..m_pos])
end


archivo_path = 'argentina.csv'

# Campos del CSV
EXPERIENCIA = 3.freeze
PUESTO = 5.freeze
TECNO = 6.freeze
TECNO2 = 7.freeze
SUELDO = 15.freeze

# Regex para machear el puesto, cambiala!
PUESTO_RX = /developer|desarrollador/i.freeze
TECNO_RX = /node|js|javascript/i.freeze
EXPERIENCIA_RX = /(8) \- /i.freeze

rows = CSV.foreach(archivo_path)
puesto_rows = rows.select{|r| r[PUESTO] =~ PUESTO_RX }

puesto_rows = puesto_rows.select{|r| (r[TECNO] =~ TECNO_RX) || (r[TECNO2] =~ TECNO_RX) } if TECNO_RX
puesto_rows = puesto_rows.select{|r| r[EXPERIENCIA] =~ EXPERIENCIA_RX } if EXPERIENCIA_RX

sueldos = puesto_rows.collect{|r| r[SUELDO].to_i }
media = median(sueldos)

puts "Datos brutos"

(1..6).each do |i|
  i = (2 + 5*2.5) - i*2.5
  puts "Registros: #{sueldos.count}",
    "Max: #{sueldos.max}",
    "Avg: #{mean(sueldos)}",
    "Med: #{media}",
    "Min: #{sueldos.min}" "",
    "Removidos outliers",""

  sueldos = sueldos.select{|s| s > media/i && s < media*i }
  media = median(sueldos)
end
