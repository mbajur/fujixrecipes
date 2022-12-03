{
  'X-Trans I' => 'xtrans1',
  'X-Trans II' => 'xtrans2',
  'X-Trans III' => 'xtrans3',
  'X-Trans IV' => 'xtrans4',
  'X-Trans V' => 'xtrans5',
  'Bayer' => 'bayer',
  'gfx' => 'gfx',
}.each do |name, slug|
  Sensor.find_or_create_by!(name: name, slug: slug)
end

[
  ['XT-4', 'xt4', 'xtrans4'],
  ['XT-5', 'xt5', 'xtrans5'],
].each do |camera, slug, sensor|
  Camera.find_or_create_by!(name: camera, slug: slug, sensor: Sensor.find_by!(slug: sensor))
end
