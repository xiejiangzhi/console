RSpec.describe Console do
  let(:cls) { Class.new { include Console } }


  describe 'include console' do
    it 'should create start method' do
      expect(cls.new).to be_respond_to(:start)
    end
  end


  describe '#start' do
    it 'should run cmd' do
      a = cls.new
      allow(Readline).to receive(:readline).and_return('help')
      # 'and_raise': stop loop
      expect(cls).to receive(:run_cmd).with(a, 'help', []).and_raise

      thread = Thread.new { a.start }
      sleep 0.1
      thread.kill
    end

    it 'should print hello' do
      expect {
        thread = Thread.new { cls.new.start('>', hello: 'hehe') }
        sleep 0.1
        thread.kill
      }.to output("hehe\n").to_stdout
    end

    it 'empty cmd, should not exec' do
      allow(Readline).to receive(:readline).and_return(nil, '', '  ')
      expect(cls).to_not receive(:run_cmd)

      thread = Thread.new { cls.new.start(nil, hello: '') }
      sleep 0.1
      thread.kill
    end

    it 'should call readline with prompt' do
      expect(Readline).to receive(:readline).with(' ===> ', true)
      thread = Thread.new { cls.new.start(' ===> ') }
      sleep 0.1
      thread.kill
    end
  end


  describe '.define_cmd' do
    it 'should create instance method' do
      expect {
        cls.define_cmd(:add, "desc") { |a, b| puts a + b }
      }.to change { cls.instance_methods.include?(:_cmd_add) }.to(true)
    end
  end


  describe '.run_cmd' do
    it 'should call command' do
      cls.define_cmd(:incr, 'incr') { @a ||=0; @a += 1 }
      a, b = cls.new, cls.new
      expect(cls.run_cmd(a, :incr)).to eq(1)
      expect(cls.run_cmd(a, :incr)).to eq(2)
      expect(cls.run_cmd(b, :incr)).to eq(1)
    end

    it 'should exec proc via console instance' do
      a = cls.new
      cls.define_cmd(:self, 'self') { self }
      expect(cls.run_cmd(a, :self)).to eq(a)
    end

    it 'invalid command, should print error' do
      a = cls.new
      expect {
        expect(cls.run_cmd(a, :aaa)).to eq(nil)
      }.to output("Invalid command 'aaa'\n").to_stdout
    end

    it 'command raise error, should print error' do
      a = cls.new
      cls.define_cmd(:error, 'error') { raise 'raise error' }

      expect {
        expect(cls.run_cmd(a, :error)).to eq(nil)
      }.to output("raise error\n").to_stdout
    end
  end
end

