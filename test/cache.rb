def setup
	$cache_x = Cache.new("filename" =>"./foo.lmc", "min_alloc_size" => 0, "size_mb" => 0)
	$cache_y = Cache.new("filename" =>"./foo.lmc", "min_alloc_size" => 0, "size_mb" => 0)
end

$assertions = {
	:success => 0,
	:failed => 0
}

setup

assert('set value') do
	assert_equal ($cache_x['test']='hello'), 'hello'
end

assert('get value') do
	assert_equal $cache_x['test'], $cache_y['test']
end

assert('shm_status keys') do
	status = $cache_x.shm_status
	assert_equal status.keys.sort, [:free_bytes, :free_chunks, :largest_chunk, :total_bytes, :used_bytes]
end

assert('delete key') do
	assert_true $cache_x.delete('test')
	assert_false $cache_y.delete('test')
end

assert('fetch deleted key') do
  assert_nil $cache_x['test']
  assert_nil $cache_y['test']
end

assert('insert data') do
  c = $cache_x
  c.clear
  assert_equal 0, c.size

  1000.times do |i|
    c["#{i.to_s}_time"] = i.to_s
    assert_equal i.to_s, c["#{i.to_s}_time"]
  end

  1000.times { |i| assert_equal(i.to_s, c["#{i.to_s}_time"]) }

  assert_equal 1000, c.size

  1000.times do |i|
    c["#{i.to_s}_time_time_time"] = i.to_s
    assert_equal i.to_s, c["#{i.to_s}_time_time_time"]
  end

  1000.times { |i| assert_equal(i.to_s, c["#{i.to_s}_time_time_time"]) }

  assert_equal 2000, c.size
end
