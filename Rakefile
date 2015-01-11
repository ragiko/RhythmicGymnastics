task :pj do
  json = File.read("tmp/sample.json")
  s = "curl -v -H 'Accept: application/json' -H 'Content-type: application/json' -X POST -d '#{json}' http://localhost:9292/pdf"
  system(s)
end

task :pj_pro do
  json = File.read("tmp/sample.json")
  s = "curl -v -H 'Accept: application/json' -H 'Content-type: application/json' -X POST -d '#{json}' http://153.121.51.112/rg/pdf"
  system(s)
end

task :pj_test do
  s = "curl -v -H 'Accept: application/json' -H 'Content-type: application/json' -X POST -d '{}' http://153.121.51.112/rg/a"
  system(s)
end
