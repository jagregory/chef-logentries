define :logentries do
  defaults = {}
  defaults.merge! params

  common = []
  common.push "--account-key #{defaults[:account_key]}" if defaults[:account_key]
  common.push "--host-key #{defaults[:host_key]}" if defaults[:host_key]
  common.push "--force" if !!defaults[:force]
  common.push "--ec2eu" if !!defaults[:ec2eu]
  common.push "--suppress-ssl" if !!defaults[:suppress_ssl]
  common.push "--yes" if !!defaults[:yes]
  common.push "--no-timestamps" if !!defaults[:no_timestamps]

  case params[:action]
  when :init
    execute "logentries init" do
      user defaults[:user]
      command 'le init'
    end
  
  when :reinit
    execute "logentries reinit" do
      user defaults[:user]
      command 'le reinit'
    end

  when :clean
    execute "logentries clean" do
      user defaults[:user]
      command 'le clean'
    end

  when :rm, :remove
    execute "logentries rm #{defaults[:name]}" do
      user defaults[:user]
      command %Q(le rm "#{defaults[:name]}")
    end

  when :pull
    execute "logentries pull #{defaults[:name]}" do
      user defaults[:user]
      command %Q(le pull "#{defaults[:name]}" #{defaults[:when]} #{defaults[:filter]} #{defaults[:limit]})
    end

  when :push
    execute "logentries push #{defaults[:name]}" do
      user defaults[:user]
      command %Q(le push "#{defaults[:name]}" #{defaults[:when]} #{defaults[:filter]} #{defaults[:limit]})
    end

  when :register
    script = ["le register", common]
    script.push %Q(--name "#{defaults[:server_name]}") if defaults[:server_name]
    script.push %Q(--hostname "#{defaults[:hostname]}") if defaults[:hostname]

    execute "logentries register" do
      user defaults[:user]
      command script.flatten.join ' '
      not_if "grep -qE '^agent-key = .+$' /etc/le/config" unless !!defaults[:force]
    end

  when :follow
    script = ["le follow", %Q("#{defaults[:name]}"), common]
    script.push %Q(--name "#{defaults[:log_name]}") if defaults[:log_name]
    script.push %Q(--type "#{defaults[:type]}") if defaults[:type]

    execute "logentries follow #{params[:name]}" do
      user defaults[:user]
      command script.flatten.join ' '
      not_if %Q(sudo le followed "#{defaults[:name]}")
    end
  end
end
