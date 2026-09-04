package ai.runapi.seedream.types;

import com.fasterxml.jackson.annotation.JsonProperty;
import java.util.List;

/** Bounding box describing a layer's position within the base image. */
public final class BoundingBox {
  @JsonProperty("absolute") private List<Integer> absolute;
  @JsonProperty("normalized") private List<Integer> normalized;

  /** Pixel coordinates [left, top, right, bottom]. */
  public List<Integer> getAbsolute() { return absolute; }

  /** Normalized coordinates. */
  public List<Integer> getNormalized() { return normalized; }
}
