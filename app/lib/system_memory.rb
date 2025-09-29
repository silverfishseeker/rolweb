module SystemMemory
  def self.info
    # Info general del sistema
    meminfo = File.read("/proc/meminfo")
    total_kb = meminfo[/MemTotal:\s+(\d+)\s+kB/, 1].to_i
    free_kb  = meminfo[/MemAvailable:\s+(\d+)\s+kB/, 1].to_i

    total_mb = total_kb / 1024.0
    free_mb  = free_kb / 1024.0
    used_mb  = total_mb - free_mb

    # Info del proceso actual
    status = File.read("/proc/self/status")
    process_kb = status[/VmRSS:\s+(\d+)\s+kB/, 1].to_i
    process_mb = process_kb / 1024.0

    {
      total_mb: total_mb.round,
      used_mb: used_mb.round,
      process_mb: process_mb.round,
      free_mb: free_mb.round
    }
  end

  def self.to_s
    mem = info
    "SystemMemory: Used: #{mem[:used_mb]} | Process: #{mem[:process_mb]} | Free: #{mem[:free_mb]} (all MB)"
  end
end
