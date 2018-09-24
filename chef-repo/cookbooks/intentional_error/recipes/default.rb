# Intentionally trigger an exception

ruby_block 'fail the run' do
  block do
    fail 'deliberately fail the run'
  end
end
