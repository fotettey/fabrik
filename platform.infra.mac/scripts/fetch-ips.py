import os

tools = ("vault", "postgres", "nexus", "sonar")

# Retrieve the environment variable
ips_str = os.getenv(env_var_name)

# Check if the environment variable is set and not empty
if not ips_str:
    print(f"Environment variable '{env_var_name}' is not set or empty.")
    exit(1)

# Split the IPs string into a list
ip_list = ips_str.split(',')

# Prepare the Ansible hosts file content
# Assuming the hosts are part of a group called 'my_servers'
ansible_hosts_content = "[my_servers]\n"
for ip in ip_list:
    ansible_hosts_content += f"{ip.strip()}\n"

# Define the output file name for the Ansible inventory file
output_file = "ansible_hosts"

# Write the formatted content to the file
with open(output_file, "w") as file:
    file.write(ansible_hosts_content)

print(f"Ansible hosts file saved to '{output_file}'")
