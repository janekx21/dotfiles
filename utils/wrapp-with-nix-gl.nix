lib: pkgs: pkg:
(pkgs.runCommand "wrapped-${pkg.meta.mainProgram}" {
  buildInputs = [pkgs.makeWrapper];
  program = pkg.meta.mainProgram;
  original = pkg;
} ''
  mkdir $out
  # Link every top-level folder from pkg to our new target
  ln -s ${pkg}/* $out
  # Except the bin folder
  rm $out/bin
  mkdir $out/bin
  # We create the bin folder ourselves and link every binary in it
  ln -s ${pkg}/bin/* $out/bin
  # Except fot the program binary
  rm $out/bin/$program

  makeWrapper "${pkgs.nixgl.nixGLIntel}/bin/nixGLIntel" "$out/bin/$program" \
    --argv0 $program \
    --add-flags "$original/bin/$program" \
'')
