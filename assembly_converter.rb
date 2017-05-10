require 'csv'

i=0

relation = {
  add:  "00000",
  addi: "00001",
  sub:  "00010",
  subi: "00011",
  nop:  "00100",
  halt: "00101",
  jump: "00110",
  beq:  "00111",
  bne:  "01000",
  slt:  "01001",
  lw:   "01010",
  li:   "01011",
  in:   "01100",
  out:  "01101",
  sw:   "01110",
  and:  "01111",
  andi: "10000",
  or:   "10001",
  ori:  "10010",
  not:  "10011",
  xor:  "10100",
  xori: "10101",
  sll:  "10110",
  srl:  "10111",
}

CSV.foreach("test.csv") do |row1|
  arr = row1[0].split(" ")
  row = "instruction_ram[#{i}] = 32'b"
  row += relation[arr[0].to_sym]
  if !arr[1].nil? && !arr[2].nil? && !arr[3].nil? # operacao contem 3 operandos
    if arr[3][0] == '$' # operacao tipo R
      row += "_#{'%05b' % arr[3][1..-1]}_#{'%05b' % arr[2][1..-2]}_#{'%05b' % arr[1][1..-2]}" # pega os numero e converte #top
      row += "%012b" % 0
    else # operacao tipo I
      if relation[arr[0].to_sym] == "10110" || relation[arr[0].to_sym] == "10111"
        row += "_00000_#{'%05b' % arr[2][1..-2]}_#{'%05b' % arr[1][1..-2]}_#{'%05b' % arr[3]}_00000_00"
      else
        row += "_#{'%05b' % arr[1][1..-2]}_#{'%05b' % arr[2][1..-2]}_#{'%017b' % arr[3]}"
      end
    end    
  elsif !arr[1].nil? && !arr[2].nil? # operacao com 2 operandos
    row += "_#{'%05b' % arr[1][1..-2]}_00000_#{'%017b' % arr[2]}"
  elsif !arr[1].nil?
    if arr[1][0] == '$'
      row += "_#{'%05b' % arr[1][1..-1]}_#{'%022b' % 0}"
    else
      row += "_#{'%05b' % arr[1]}_#{'%022b' % 0}"
    end
  else
    row += "_" + "%027b" % 0
  end

  puts row
  i=i+1
end