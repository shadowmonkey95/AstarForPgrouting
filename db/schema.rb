# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180403014724) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"
  enable_extension "postgis"

  create_table "configuration", id: :integer, default: nil, force: :cascade do |t|
    t.integer "tag_id"
    t.text "tag_key"
    t.text "tag_value"
    t.float "priority"
    t.float "maxspeed"
    t.float "maxspeed_forward"
    t.float "maxspeed_backward"
    t.string "force", limit: 1
    t.index ["tag_id"], name: "configuration_tag_id_key", unique: true
  end

  create_table "locations", force: :cascade do |t|
    t.integer "shipper_id"
    t.string "latitude"
    t.string "longtitude"
    t.string "timestamp"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "migrations", id: :integer, default: nil, force: :cascade do |t|
    t.string "migration", limit: 255, null: false
    t.integer "batch", null: false
  end

  create_table "password_resets", id: false, force: :cascade do |t|
    t.string "email", limit: 255, null: false
    t.string "token", limit: 255, null: false
    t.datetime "created_at", precision: 0
    t.index ["email"], name: "password_resets_email_index"
  end

  create_table "planet_osm_line", id: false, force: :cascade do |t|
    t.bigint "osm_id"
    t.text "access"
    t.text "addr:housename"
    t.text "addr:housenumber"
    t.text "addr:interpolation"
    t.text "admin_level"
    t.text "aerialway"
    t.text "aeroway"
    t.text "amenity"
    t.text "area"
    t.text "barrier"
    t.text "bicycle"
    t.text "brand"
    t.text "bridge"
    t.text "boundary"
    t.text "building"
    t.text "construction"
    t.text "covered"
    t.text "culvert"
    t.text "cutting"
    t.text "denomination"
    t.text "disused"
    t.text "embankment"
    t.text "foot"
    t.text "generator:source"
    t.text "harbour"
    t.text "highway"
    t.text "historic"
    t.text "horse"
    t.text "intermittent"
    t.text "junction"
    t.text "landuse"
    t.text "layer"
    t.text "leisure"
    t.text "lock"
    t.text "man_made"
    t.text "military"
    t.text "motorcar"
    t.text "name"
    t.text "natural"
    t.text "office"
    t.text "oneway"
    t.text "operator"
    t.text "place"
    t.text "population"
    t.text "power"
    t.text "power_source"
    t.text "public_transport"
    t.text "railway"
    t.text "ref"
    t.text "religion"
    t.text "route"
    t.text "service"
    t.text "shop"
    t.text "sport"
    t.text "surface"
    t.text "toll"
    t.text "tourism"
    t.text "tower:type"
    t.text "tracktype"
    t.text "tunnel"
    t.text "water"
    t.text "waterway"
    t.text "wetland"
    t.text "width"
    t.text "wood"
    t.integer "z_order"
    t.float "way_area"
    t.geometry "way", limit: {:srid=>3857, :type=>"line_string"}
    t.index ["osm_id"], name: "planet_osm_line_pkey"
    t.index ["way"], name: "planet_osm_line_index", using: :gist
  end

  create_table "planet_osm_nodes", id: :bigint, default: nil, force: :cascade do |t|
    t.integer "lat", null: false
    t.integer "lon", null: false
  end

  create_table "planet_osm_point", id: false, force: :cascade do |t|
    t.bigint "osm_id"
    t.text "access"
    t.text "addr:housename"
    t.text "addr:housenumber"
    t.text "addr:interpolation"
    t.text "admin_level"
    t.text "aerialway"
    t.text "aeroway"
    t.text "amenity"
    t.text "area"
    t.text "barrier"
    t.text "bicycle"
    t.text "brand"
    t.text "bridge"
    t.text "boundary"
    t.text "building"
    t.text "capital"
    t.text "construction"
    t.text "covered"
    t.text "culvert"
    t.text "cutting"
    t.text "denomination"
    t.text "disused"
    t.text "ele"
    t.text "embankment"
    t.text "foot"
    t.text "generator:source"
    t.text "harbour"
    t.text "highway"
    t.text "historic"
    t.text "horse"
    t.text "intermittent"
    t.text "junction"
    t.text "landuse"
    t.text "layer"
    t.text "leisure"
    t.text "lock"
    t.text "man_made"
    t.text "military"
    t.text "motorcar"
    t.text "name"
    t.text "natural"
    t.text "office"
    t.text "oneway"
    t.text "operator"
    t.text "place"
    t.text "population"
    t.text "power"
    t.text "power_source"
    t.text "public_transport"
    t.text "railway"
    t.text "ref"
    t.text "religion"
    t.text "route"
    t.text "service"
    t.text "shop"
    t.text "sport"
    t.text "surface"
    t.text "toll"
    t.text "tourism"
    t.text "tower:type"
    t.text "tunnel"
    t.text "water"
    t.text "waterway"
    t.text "wetland"
    t.text "width"
    t.text "wood"
    t.integer "z_order"
    t.geometry "way", limit: {:srid=>3857, :type=>"st_point"}
    t.index ["osm_id"], name: "planet_osm_point_pkey"
    t.index ["way"], name: "planet_osm_point_index", using: :gist
  end

  create_table "planet_osm_polygon", id: false, force: :cascade do |t|
    t.bigint "osm_id"
    t.text "access"
    t.text "addr:housename"
    t.text "addr:housenumber"
    t.text "addr:interpolation"
    t.text "admin_level"
    t.text "aerialway"
    t.text "aeroway"
    t.text "amenity"
    t.text "area"
    t.text "barrier"
    t.text "bicycle"
    t.text "brand"
    t.text "bridge"
    t.text "boundary"
    t.text "building"
    t.text "construction"
    t.text "covered"
    t.text "culvert"
    t.text "cutting"
    t.text "denomination"
    t.text "disused"
    t.text "embankment"
    t.text "foot"
    t.text "generator:source"
    t.text "harbour"
    t.text "highway"
    t.text "historic"
    t.text "horse"
    t.text "intermittent"
    t.text "junction"
    t.text "landuse"
    t.text "layer"
    t.text "leisure"
    t.text "lock"
    t.text "man_made"
    t.text "military"
    t.text "motorcar"
    t.text "name"
    t.text "natural"
    t.text "office"
    t.text "oneway"
    t.text "operator"
    t.text "place"
    t.text "population"
    t.text "power"
    t.text "power_source"
    t.text "public_transport"
    t.text "railway"
    t.text "ref"
    t.text "religion"
    t.text "route"
    t.text "service"
    t.text "shop"
    t.text "sport"
    t.text "surface"
    t.text "toll"
    t.text "tourism"
    t.text "tower:type"
    t.text "tracktype"
    t.text "tunnel"
    t.text "water"
    t.text "waterway"
    t.text "wetland"
    t.text "width"
    t.text "wood"
    t.integer "z_order"
    t.float "way_area"
    t.geometry "way", limit: {:srid=>3857, :type=>"geometry"}
    t.index ["osm_id"], name: "planet_osm_polygon_pkey"
    t.index ["way"], name: "planet_osm_polygon_index", using: :gist
  end

  create_table "planet_osm_rels", id: :bigint, default: nil, force: :cascade do |t|
    t.integer "way_off", limit: 2
    t.integer "rel_off", limit: 2
    t.bigint "parts", array: true
    t.text "members", array: true
    t.text "tags", array: true
    t.index ["parts"], name: "planet_osm_rels_parts", using: :gin
  end

  create_table "planet_osm_roads", id: false, force: :cascade do |t|
    t.bigint "osm_id"
    t.text "access"
    t.text "addr:housename"
    t.text "addr:housenumber"
    t.text "addr:interpolation"
    t.text "admin_level"
    t.text "aerialway"
    t.text "aeroway"
    t.text "amenity"
    t.text "area"
    t.text "barrier"
    t.text "bicycle"
    t.text "brand"
    t.text "bridge"
    t.text "boundary"
    t.text "building"
    t.text "construction"
    t.text "covered"
    t.text "culvert"
    t.text "cutting"
    t.text "denomination"
    t.text "disused"
    t.text "embankment"
    t.text "foot"
    t.text "generator:source"
    t.text "harbour"
    t.text "highway"
    t.text "historic"
    t.text "horse"
    t.text "intermittent"
    t.text "junction"
    t.text "landuse"
    t.text "layer"
    t.text "leisure"
    t.text "lock"
    t.text "man_made"
    t.text "military"
    t.text "motorcar"
    t.text "name"
    t.text "natural"
    t.text "office"
    t.text "oneway"
    t.text "operator"
    t.text "place"
    t.text "population"
    t.text "power"
    t.text "power_source"
    t.text "public_transport"
    t.text "railway"
    t.text "ref"
    t.text "religion"
    t.text "route"
    t.text "service"
    t.text "shop"
    t.text "sport"
    t.text "surface"
    t.text "toll"
    t.text "tourism"
    t.text "tower:type"
    t.text "tracktype"
    t.text "tunnel"
    t.text "water"
    t.text "waterway"
    t.text "wetland"
    t.text "width"
    t.text "wood"
    t.integer "z_order"
    t.float "way_area"
    t.geometry "way", limit: {:srid=>3857, :type=>"line_string"}
    t.index ["osm_id"], name: "planet_osm_roads_pkey"
    t.index ["way"], name: "planet_osm_roads_index", using: :gist
  end

  create_table "planet_osm_ways", id: :bigint, default: nil, force: :cascade do |t|
    t.bigint "nodes", null: false, array: true
    t.text "tags", array: true
    t.index ["nodes"], name: "planet_osm_ways_nodes", using: :gin
  end

  create_table "pointsofinterest", primary_key: "pid", force: :cascade do |t|
    t.bigint "osm_id"
    t.bigint "vertex_id"
    t.bigint "edge_id"
    t.string "side", limit: 1
    t.float "fraction"
    t.float "length_m"
    t.text "tag_name"
    t.text "tag_value"
    t.text "name"
    t.geometry "the_geom", limit: {:srid=>4326, :type=>"st_point"}
    t.geometry "new_geom", limit: {:srid=>4326, :type=>"st_point"}
    t.index ["osm_id"], name: "pointsofinterest_osm_id_key", unique: true
    t.index ["the_geom"], name: "pointsofinterest_the_geom_idx", using: :gist
  end

  create_table "requests", force: :cascade do |t|
    t.integer "shop_id"
    t.string "destination_address"
    t.integer "shipper_id"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "shippers", force: :cascade do |t|
    t.string "first_name"
    t.string "second_name"
    t.string "email"
    t.string "password"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "shops", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.string "lon"
    t.string "lat"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "vertices", force: :cascade do |t|
    t.bigint "osm_id"
    t.integer "eout"
    t.decimal "lon", precision: 11, scale: 8
    t.decimal "lat", precision: 11, scale: 8
    t.integer "cnt"
    t.integer "chk"
    t.integer "ein"
    t.geometry "the_geom", limit: {:srid=>4326, :type=>"st_point"}
    t.index ["osm_id"], name: "vertices_osm_id_key", unique: true
    t.index ["the_geom"], name: "vertices_the_geom_idx", using: :gist
  end

  create_table "ways", primary_key: "gid", force: :cascade do |t|
    t.bigint "osm_id"
    t.integer "tag_id"
    t.float "length"
    t.float "length_m"
    t.text "name"
    t.bigint "source"
    t.bigint "target"
    t.bigint "source_osm"
    t.bigint "target_osm"
    t.float "cost"
    t.float "reverse_cost"
    t.float "cost_s"
    t.float "reverse_cost_s"
    t.text "rule"
    t.integer "one_way"
    t.text "oneway"
    t.float "x1"
    t.float "y1"
    t.float "x2"
    t.float "y2"
    t.float "maxspeed_forward"
    t.float "maxspeed_backward"
    t.float "priority", default: 1.0
    t.geometry "the_geom", limit: {:srid=>4326, :type=>"line_string"}
    t.index ["the_geom"], name: "ways_the_geom_idx", using: :gist
  end

  create_table "ways_vertices_pgr", force: :cascade do |t|
    t.bigint "osm_id"
    t.integer "eout"
    t.decimal "lon", precision: 11, scale: 8
    t.decimal "lat", precision: 11, scale: 8
    t.integer "cnt"
    t.integer "chk"
    t.integer "ein"
    t.geometry "the_geom", limit: {:srid=>4326, :type=>"st_point"}
    t.index ["osm_id"], name: "ways_vertices_pgr_osm_id_key", unique: true
    t.index ["the_geom"], name: "ways_vertices_pgr_the_geom_idx", using: :gist
  end

  add_foreign_key "ways", "configuration", column: "tag_id", primary_key: "tag_id", name: "ways_tag_id_fkey"
  add_foreign_key "ways", "ways_vertices_pgr", column: "source", name: "ways_source_fkey"
  add_foreign_key "ways", "ways_vertices_pgr", column: "source_osm", primary_key: "osm_id", name: "ways_source_osm_fkey"
  add_foreign_key "ways", "ways_vertices_pgr", column: "target", name: "ways_target_fkey"
  add_foreign_key "ways", "ways_vertices_pgr", column: "target_osm", primary_key: "osm_id", name: "ways_target_osm_fkey"
end
