include UnlimitedCache
include Maintenance

class AdminController < ApplicationController

    configure_access :restore_backup, level: :superadmin

    def control
    end

    def habilidads_ocultas
        redirect_to habilidads_path(mode: "hidden")
    end

    def habilidads_sueltas
        redirect_to habilidads_path(mode: "sueltas")
    end

    def items_no_categ
    end

    def delete_disk_cache
        DiskCache.clear_disk_cache!
        redirect_to "/control", notice: "Caché de disco eliminada"
    end

    def delete_navbar_cache
        inner_delete_navbar_cache
        redirect_to "/control", notice: "Caché de la barra de navegación eliminada"
    end

    def delete_all_cache
        cache_clear
        redirect_to "/control", notice: "Caché de memoria eliminada"
    end

    def delete_session_data
        session.clear
        redirect_to "/control", notice: "Datos de sesión eliminados"
    end
    
    def backup
    end

    def create_backup
        backup_file = nil
        begin
            with_maintenance do # Stops any other actions in ApplicationController
                backup_file = Backup.create(params[:skip_images] == "1")
            end
            data = File.binread(backup_file)

            send_data data,
                type: "application/gzip",
                disposition: "attachment",
                filename: File.basename(backup_file)
        rescue => e
            Rails.logger.error "❌ Backup failed: #{e.message} in #{e.backtrace.first}"
            Rails.logger.error e.backtrace.join("\n")
            redirect_to "/backup", alert: "Backup failed: #{e.message} in #{e.backtrace.first}"
        ensure
            if backup_file && File.exist?(backup_file)
                File.delete(backup_file)
                Rails.logger.info "🧹 Deleted temporary backup file #{backup_file}"
            else
                Rails.logger.warn "⚠️ Temporary backup file #{backup_file} does not exist or was not created."
            end
        end
    end

    def restore_backup
        if params[:backup_file].present?
            begin
                with_maintenance do # Stops any other actions in ApplicationController
                    Backup.restore(
                        params[:backup_file].tempfile.path,
                        params[:resume] == "1",
                        params[:tolerante] == "1",
                        params[:no_rollback] != "1",
                        params[:allow_missing_imgs] == "1",
                        params[:skip_gifs] == "1",
                        params[:use_max_file_size] == "1" ? params[:max_file_size_mb] : false,
                        params[:gc] == "1"
                    )
                end
                inner_delete_navbar_cache
                redirect_to "/backup", notice: "Backup restored successfully."
            rescue => e
                Rails.logger.error "❌ Restore (#{params[:mode]=="1" ? "flexible" : "strict"}) failed: #{e.message}\n#{e.backtrace.join("\n")}"
                redirect_to "/backup", alert: "Restore failed: #{e.message}"
            end
        else
            redirect_to "/backup", alert: "No backup file provided."
        end
    end

    def download_logs
        log_file = Rails.root.join("log", "#{Rails.env}.log")

        if File.exist?(log_file)
            send_file log_file,
                    type: "text/plain",
                    disposition: "attachment",
                    filename: "#{Rails.env}_logs.txt"
        else
            redirect_to "/control", alert: "El archivo de logs no existe."
        end
    end

    def ritual
    end

    def test_mail
        TestMailer.probe_email.deliver_now
        redirect_to "/control", notice: "Correo enviado correctamente"
    rescue => e
        redirect_to "/control", alert: "Error al enviar correo: #{e.message}"
    end

    private

    def inner_delete_navbar_cache
        cache_delete "clases_ocultas"
        cache_delete "clases_visibles"
        cache_delete "categorias"
        cache_delete "cuento_first"
    end
end

