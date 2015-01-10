task :pj do
  json = File.read("tmp/sample.json")
  s = "curl -v -H 'Accept: application/json' -H 'Content-type: application/json' -X POST -d '#{json}' http://localhost:9292/pdf"
  system(s)
end
