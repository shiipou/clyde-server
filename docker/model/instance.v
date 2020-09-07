module docker

pub struct InstanceModel {
pub mut:
	id               string              [json: ID]
	names            []string            [json: Names]
	image            string              [json: Image]
	image_id         string              [json: ImageID]
	command          string              [json: Command]
	ports            []string            [json: Image]
	creation_date    int                 [json: Created]
	labels           map[string]string   [json: Labels]
	state            string              [json: Labels]
	status           string              [json: Status]
	host_config      map[string]string   [json: HostConfig]
	network_settings map[string]string   [json: NetworkSettings]
	mounts           []string            [json: Mounts]
}
