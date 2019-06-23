def pr_to_the_master?
  github.branch_for_base == "master"
end

def pr_to_the_develop?
  github.branch_for_base == "develop"
end

def release?
  github.pr_title.match(/\ARelease/i)
end

def hotfix?
  github.pr_title.match(/\A\[Hotfix\]/i)
end

# determine if any of the files were modified
def did_modify?(files_array)
  files_array.any? do |file_name|
    git.modified_files.include?(file_name) || git.deleted_files.include?(file_name)
  end
end

# You've made changes to lib, but didn't write any tests?
def tests
  has_app_changes = !git.modified_files.grep(/\Alib/).empty?
  has_spec_changes = !git.modified_files.grep(/\Aspec/).empty?

  if has_app_changes && !has_spec_changes
    warn("There're code changes, but not tests. That's fine only if you're refactoring existing code.", sticky: true)
  end
end

# Warn when there is a big PR
def big_pr
  warn("This seems to be a big PR. :eyes:") if git.lines_of_code > 500
end

# Remind that ENV variables changes should be repeated for deployment scripts
def remind_env_vars_update
  warn(":warning: Changed env file sample. Don't forget to update ansible-playbooks. :warning:", sticky: true) if did_modify?([".env.sample"])
end

# Don't let debugging shortcuts get into master by accident
def debugging_info
  look_for_binding_pry = `grep -r binding.pry config/ lib/ spec/`
  fail("binding.pry left in the code at:\n#{look_for_binding_pry}") if look_for_binding_pry.length > 1
end


###################################################################################
# Run!
###################################################################################
if pr_to_the_master?
  release_or_hotfix_only
else
  ticket_number
  big_pr
  merge_commits
end

pr_description
pr_labels
wip_pr
tests
remind_env_vars_update
debugging_info
commit_message unless release
