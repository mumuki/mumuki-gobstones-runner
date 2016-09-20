module Fixture
  def q1_ok_program
%q{
MOV R3, 0x0003
MOV R5, 0x0004
ADD R3, R5
}
  end

  def syntax_error_program
    'MOB R3, 0x0003'
  end

  def runtime_error_program
    'CALL unknown'
  end
end