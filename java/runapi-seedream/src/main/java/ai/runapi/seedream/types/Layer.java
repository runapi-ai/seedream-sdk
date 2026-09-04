package ai.runapi.seedream.types;

import com.fasterxml.jackson.annotation.JsonProperty;

/** A decomposed layer with its position and metadata. */
public final class Layer {
  @JsonProperty("url") private String url;
  @JsonProperty("z_index") private int zIndex;
  @JsonProperty("bounding_box") private BoundingBox boundingBox;
  @JsonProperty("name") private String name;
  @JsonProperty("description") private String description;

  /** Returns the layer image URL. */
  public String getUrl() { return url; }

  /** Returns the layer stacking order. */
  public int getZIndex() { return zIndex; }

  /** Returns the bounding box, or null if not provided. */
  public BoundingBox getBoundingBox() { return boundingBox; }

  /** Returns the layer name, or null if not provided. */
  public String getName() { return name; }

  /** Returns the layer description, or null if not provided. */
  public String getDescription() { return description; }
}
