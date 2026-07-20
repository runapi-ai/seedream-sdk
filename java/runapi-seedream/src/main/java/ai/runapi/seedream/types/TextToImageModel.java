package ai.runapi.seedream.types;

import com.fasterxml.jackson.annotation.JsonCreator;

/** Model slug for text to image operations. */
public final class TextToImageModel extends SeedreamValue {
  /** seedream-4.5-text-to-image model slug. */
  public static final TextToImageModel SEEDREAM_4_5_TEXT_TO_IMAGE = new TextToImageModel("seedream-4.5-text-to-image");
  /** seedream-5-lite-text-to-image model slug. */
  public static final TextToImageModel SEEDREAM_5_LITE_TEXT_TO_IMAGE = new TextToImageModel("seedream-5-lite-text-to-image");
  /** seedream-5-pro-text-to-image model slug. */
  public static final TextToImageModel SEEDREAM_5_PRO_TEXT_TO_IMAGE = new TextToImageModel("seedream-5-pro-text-to-image");
  /** seedream-v4-text-to-image model slug. */
  public static final TextToImageModel SEEDREAM_V4_TEXT_TO_IMAGE = new TextToImageModel("seedream-v4-text-to-image");

  /** Creates a model value from a literal model slug. */
  @JsonCreator
  public TextToImageModel(String value) {
    super(value);
  }
}
