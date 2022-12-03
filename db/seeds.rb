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
  ['XT-5', 'xt5', 'xtrans5'],
  ['XT-4', 'xt4', 'xtrans4'],
  ['XT-3', 'xt3', 'xtrans4'],
  ['XT-2', 'xt2', 'xtrans3'],
  ['XT-1', 'xt1', 'xtrans2'],

  ['XE-4', 'xe4', 'xtrans4'],
  ['XE-3', 'xe3', 'xtrans3'],
  ['XE-2', 'xe2', 'xtrans2'],
  ['XE-1', 'xe1', 'xtrans1'],

  ['X-Pro3', 'xpro3', 'xtrans4'],
  ['X-Pro2', 'xpro2', 'xtrans3'],
  ['X-Pro1', 'xpro1', 'xtrans1'],

  ['X100V', 'x100v', 'xtrans4'],
  ['X100F', 'x100f', 'xtrans3'],
  ['X100S', 'x100s', 'xtrans2'],
  ['X100T', 'x100t', 'xtrans2'],
].each do |camera, slug, sensor|
  Camera.find_or_create_by!(name: camera, slug: slug, sensor: Sensor.find_by!(slug: sensor))
end
