# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_06_30_141702) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "clases", force: :cascade do |t|
    t.string "nombre"
    t.integer "nivel"
    t.text "efecto"
    t.text "descripcion"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image"
  end

  create_table "clases_habilidads", id: false, force: :cascade do |t|
    t.bigint "clase_id", null: false
    t.bigint "habilidad_id", null: false
    t.index ["clase_id", "habilidad_id"], name: "index_clases_habilidads_on_clase_id_and_habilidad_id"
    t.index ["habilidad_id", "clase_id"], name: "index_clases_habilidads_on_habilidad_id_and_clase_id"
  end

  create_table "clases_items", id: false, force: :cascade do |t|
    t.bigint "clase_id", null: false
    t.bigint "item_id", null: false
    t.index ["clase_id", "item_id"], name: "index_clases_items_on_clase_id_and_item_id"
    t.index ["item_id", "clase_id"], name: "index_clases_items_on_item_id_and_clase_id"
  end

  create_table "habilidads", force: :cascade do |t|
    t.string "nombre"
    t.integer "nivel"
    t.string "efecto"
    t.string "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "habilidads_items", id: false, force: :cascade do |t|
    t.bigint "item_id", null: false
    t.bigint "habilidad_id", null: false
    t.index ["habilidad_id", "item_id"], name: "index_habilidads_items_on_habilidad_id_and_item_id"
    t.index ["item_id", "habilidad_id"], name: "index_habilidads_items_on_item_id_and_habilidad_id"
  end

  create_table "items", force: :cascade do |t|
    t.string "nombre"
    t.decimal "coste"
    t.decimal "peso"
    t.text "efecto"
    t.string "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pictures", force: :cascade do |t|
    t.string "nombre"
    t.string "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
