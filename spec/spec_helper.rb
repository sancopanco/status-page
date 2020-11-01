require "status_page"
require "pry"
# FIXTURES_PATH = File.expand_path("../lib", __FILE__)

def status_page(args)
  capture_stdout do
    begin
      StatusPage::CLI.start(args.split(" "))
    rescue SystemExit
    end
  end
end

def capture_stdout
  old_stdout = $stdout.dup
  rd, wr = make_pipe
  $stdout = wr
  yield
  wr.close
  rd.read
ensure
  $stdout = old_stdout
end

def make_pipe
  IO.method(:pipe).arity.zero? ? IO.pipe : IO.pipe("BINARY")
end