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

ActiveRecord::Schema[8.0].define(version: 2025_11_03_174316) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "carrierwave_images", force: :cascade do |t|
    t.string "nombre"
    t.string "file"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categs", force: :cascade do |t|
    t.string "nombre"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categs_clases", id: false, force: :cascade do |t|
    t.bigint "clase_id", null: false
    t.bigint "categ_id", null: false
  end

  create_table "categs_contextoloots", id: false, force: :cascade do |t|
    t.bigint "contextoloot_id", null: false
    t.bigint "categ_id", null: false
  end

  create_table "categs_habilidads", id: false, force: :cascade do |t|
    t.bigint "categ_id", null: false
    t.bigint "habilidad_id", null: false
    t.index ["categ_id", "habilidad_id"], name: "index_categs_habilidads_on_categ_id_and_habilidad_id"
    t.index ["habilidad_id", "categ_id"], name: "index_categs_habilidads_on_habilidad_id_and_categ_id"
  end

  create_table "categs_items", id: false, force: :cascade do |t|
    t.bigint "item_id", null: false
    t.bigint "categ_id", null: false
    t.index ["categ_id", "item_id"], name: "index_categs_items_on_categ_id_and_item_id"
    t.index ["item_id", "categ_id"], name: "index_categs_items_on_item_id_and_categ_id"
  end

  create_table "clases", force: :cascade do |t|
    t.string "nombre"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image"
    t.boolean "oculto", default: false, null: false
    t.boolean "raza", default: false, null: false
    t.boolean "radical", default: false, null: false
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

  create_table "clases_relations", force: :cascade do |t|
    t.integer "parent_id"
    t.integer "child_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "contextoloots", force: :cascade do |t|
    t.string "nombre"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "contextoloots_items", id: false, force: :cascade do |t|
    t.bigint "contextoloot_id", null: false
    t.bigint "item_id", null: false
  end

  create_table "cuento_relations", force: :cascade do |t|
    t.integer "parent_id"
    t.integer "child_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cuentos", force: :cascade do |t|
    t.string "nombre"
    t.boolean "spoilers"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "prioridad"
    t.string "titulo"
  end

  create_table "cuentos_etiquets", id: false, force: :cascade do |t|
    t.bigint "cuento_id", null: false
    t.bigint "etiquet_id", null: false
    t.index ["cuento_id", "etiquet_id"], name: "index_cuentos_etiquets_on_cuento_id_and_etiquet_id"
  end

  create_table "cuentos_mobs", id: false, force: :cascade do |t|
    t.bigint "cuento_id", null: false
    t.bigint "mob_id", null: false
  end

  create_table "cuentos_pictures", id: false, force: :cascade do |t|
    t.bigint "cuento_id", null: false
    t.bigint "picture_id", null: false
    t.index ["cuento_id", "picture_id"], name: "index_cuentos_pictures_on_cuento_id_and_picture_id"
  end

  create_table "estadoalterados", force: :cascade do |t|
    t.string "nombre"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "etiquets", force: :cascade do |t|
    t.string "nombre"
    t.string "color"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "etiquets_pictures", id: false, force: :cascade do |t|
    t.bigint "etiquet_id", null: false
    t.bigint "picture_id", null: false
    t.index ["etiquet_id", "picture_id"], name: "index_etiquets_pictures_on_etiquet_id_and_picture_id"
    t.index ["picture_id", "etiquet_id"], name: "index_etiquets_pictures_on_picture_id_and_etiquet_id"
  end

  create_table "habilidads", force: :cascade do |t|
    t.string "nombre"
    t.integer "nivel"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "oculto", default: false
    t.integer "tipo"
    t.string "image"
  end

  create_table "habilidads_items", id: false, force: :cascade do |t|
    t.bigint "item_id", null: false
    t.bigint "habilidad_id", null: false
    t.index ["habilidad_id", "item_id"], name: "index_habilidads_items_on_habilidad_id_and_item_id"
    t.index ["item_id", "habilidad_id"], name: "index_habilidads_items_on_item_id_and_habilidad_id"
  end

  create_table "habilidads_mobs", id: false, force: :cascade do |t|
    t.bigint "habilidad_id", null: false
    t.bigint "mob_id", null: false
    t.index ["habilidad_id", "mob_id"], name: "index_habilidads_mobs_on_habilidad_id_and_mob_id"
    t.index ["mob_id", "habilidad_id"], name: "index_habilidads_mobs_on_mob_id_and_habilidad_id"
  end

  create_table "images", force: :cascade do |t|
    t.binary "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "nombre"
  end

  create_table "items", force: :cascade do |t|
    t.string "nombre"
    t.decimal "coste"
    t.decimal "peso"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image"
  end

  create_table "items_mobs", id: false, force: :cascade do |t|
    t.bigint "mob_id", null: false
    t.bigint "item_id", null: false
    t.index ["item_id", "mob_id"], name: "index_items_mobs_on_item_id_and_mob_id"
    t.index ["mob_id", "item_id"], name: "index_items_mobs_on_mob_id_and_item_id"
  end

  create_table "mobs", force: :cascade do |t|
    t.string "nombre"
    t.string "image"
    t.integer "estabilidad"
    t.integer "armaduraMagica"
    t.integer "penetracionFisica"
    t.integer "penetracionMagica"
    t.integer "sangre"
    t.decimal "oro"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "mobs_has_habils", force: :cascade do |t|
    t.integer "mob_id"
    t.integer "habilidad_id"
    t.index ["habilidad_id", "mob_id"], name: "index_mobs_has_habils_on_habilidad_id_and_mob_id"
    t.index ["mob_id", "habilidad_id"], name: "index_mobs_has_habils_on_mob_id_and_habilidad_id"
  end

  create_table "pictures", force: :cascade do |t|
    t.string "nombre"
    t.string "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ritual_ritual_clase_rel_rituals", force: :cascade do |t|
    t.integer "cantidad"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "ritual_id", null: false
    t.bigint "ritual_clase_id", null: false
    t.index ["ritual_clase_id"], name: "index_ritual_ritual_clase_rel_rituals_on_ritual_clase_id"
    t.index ["ritual_id"], name: "index_ritual_ritual_clase_rel_rituals_on_ritual_id"
  end

  create_table "ritual_ritual_clases", force: :cascade do |t|
    t.string "valor"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ritual_ritual_coste_rel_rituals", force: :cascade do |t|
    t.integer "cantidad"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "ritual_id", null: false
    t.bigint "ritual_coste_id", null: false
    t.index ["ritual_coste_id"], name: "index_ritual_ritual_coste_rel_rituals_on_ritual_coste_id"
    t.index ["ritual_id"], name: "index_ritual_ritual_coste_rel_rituals_on_ritual_id"
  end

  create_table "ritual_ritual_costes", force: :cascade do |t|
    t.string "valor"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ritual_ritual_nivel_rel_rituals", force: :cascade do |t|
    t.integer "cantidad"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "ritual_id", null: false
    t.bigint "ritual_nivel_id", null: false
    t.index ["ritual_id"], name: "index_ritual_ritual_nivel_rel_rituals_on_ritual_id"
    t.index ["ritual_nivel_id"], name: "index_ritual_ritual_nivel_rel_rituals_on_ritual_nivel_id"
  end

  create_table "ritual_ritual_nivels", force: :cascade do |t|
    t.integer "valor"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ritual_rituals", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "item_id"
    t.index ["item_id"], name: "index_ritual_rituals_on_item_id"
  end

  create_table "ritualclases", force: :cascade do |t|
    t.string "valor"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ritualcostes", force: :cascade do |t|
    t.string "valor"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ritualnivels", force: :cascade do |t|
    t.integer "valor"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rituals", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "ritual_ritual_clase_rel_rituals", "ritual_ritual_clases", column: "ritual_clase_id"
  add_foreign_key "ritual_ritual_clase_rel_rituals", "ritual_rituals", column: "ritual_id"
  add_foreign_key "ritual_ritual_coste_rel_rituals", "ritual_ritual_costes", column: "ritual_coste_id"
  add_foreign_key "ritual_ritual_coste_rel_rituals", "ritual_rituals", column: "ritual_id"
  add_foreign_key "ritual_ritual_nivel_rel_rituals", "ritual_ritual_nivels", column: "ritual_nivel_id"
  add_foreign_key "ritual_ritual_nivel_rel_rituals", "ritual_rituals", column: "ritual_id"
  add_foreign_key "ritual_rituals", "items"
end
