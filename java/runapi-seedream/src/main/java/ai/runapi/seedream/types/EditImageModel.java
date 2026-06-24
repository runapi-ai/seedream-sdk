package ai.runapi.seedream.types;

import com.fasterxml.jackson.annotation.JsonCreator;

/** Model slug for edit image operations. */
public final class EditImageModel extends SeedreamValue {
  /** seedream-4.5-edit model slug. */
  public static final EditImageModel SEEDREAM_4_5_EDIT = new EditImageModel("seedream-4.5-edit");
  /** seedream-5-lite-edit model slug. */
  public static final EditImageModel SEEDREAM_5_LITE_EDIT = new EditImageModel("seedream-5-lite-edit");
  /** seedream-v4-edit model slug. */
  public static final EditImageModel SEEDREAM_V4_EDIT = new EditImageModel("seedream-v4-edit");

  /** Creates a model value from a literal model slug. */
  @JsonCreator
  public EditImageModel(String value) {
    super(value);
  }
}
