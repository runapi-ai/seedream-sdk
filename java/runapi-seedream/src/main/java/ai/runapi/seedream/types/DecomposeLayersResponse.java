package ai.runapi.seedream.types;

import ai.runapi.core.errors.ValidationException;
import ai.runapi.core.polling.AbstractTaskResponse;
import ai.runapi.core.polling.Poller;
import ai.runapi.core.polling.TaskStatus;
import com.fasterxml.jackson.annotation.JsonAnyGetter;
import com.fasterxml.jackson.annotation.JsonAnySetter;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.databind.JsonNode;
import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/** Response for layer decomposition operations. */
public class DecomposeLayersResponse extends AbstractTaskResponse implements Poller.CompletedResult {
  @JsonProperty("id") private String id;
  @JsonProperty("status") private String status;
  @JsonProperty("error") private String error;
  @JsonProperty("base_image") private Image baseImage;
  @JsonProperty("layers") private List<Layer> layers;
  private final Map<String, JsonNode> extraFields = new LinkedHashMap<String, JsonNode>();

  public String getId() { return id; }
  public TaskStatus getStatus() { return new TaskStatus(status == null ? "" : status); }
  public String getError() { return error; }
  public Image getBaseImage() { return baseImage; }
  public List<Layer> getLayers() { return layers == null ? null : Collections.unmodifiableList(layers); }

  @JsonAnyGetter
  public Map<String, JsonNode> extraFields() { return Collections.unmodifiableMap(extraFields); }

  public void ensureResultPresent() {
    if (baseImage == null || layers == null) {
      throw new ValidationException("completed task response is missing base_image or layers");
    }
  }

  @JsonAnySetter
  void putExtraField(String name, JsonNode value) { extraFields.put(name, value); }
}
