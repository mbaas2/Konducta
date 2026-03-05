:Class Hash  ⍝ from BHC by mail to MB
    ⎕io←1⋄⎕ml←1
    :field public hash    ⍝ Name of hash
    ⍝:field private shared  sharedlib←'conga34ssl64'    ⍝ MB
    :field private shared  ∆sharedlib←'conga{CongaVersion}ssl64'   ⍝ MB
    :field public shared CongaPath←''                              ⍝ MB
    :field public shared CongaVersion←''                           ⍝ MB
    :field private ctx    ⍝ hash context
    :field private dsize  ⍝ digest size
    :field private key←⍬ ⍝

    AddTrailingSlash←{0=≢⍵:⍵⋄⍵,('/'≠⊢/⍵)/'/'}

    ∇ r←hex a
      :Access public shared
      r←,⍉(⎕D,⎕C ⎕A)[1+16 16⊤a]
    ∇

    ∇ R←sharedlib;pre;pre2
      pre←AddTrailingSlash CongaPath
      :If 0=≢1⊃⎕NPARTS ∆sharedlib
          pre2←2 ⎕NQ'.' 'GetEnvironment' 'DYALOG'
          pre2←AddTrailingSlash pre2
          :Select ⎕C ⎕SE.SALTUtils.OS
          :Case 'mac'
              pre2,←'lib/'
              ∆sharedlib←'libconga{CongaVersion}ssl64.dylib'
          :Case 'win'      ⍝ default settings are ok
          :Case 'lin'
              pre2,←'lib/'
              ∆sharedlib←'libconga{CongaVersion}ssl',(⍕⎕SE.SALTUtils.BITS),'.so'
          :Case 'aix'
              pre2,←'lib/'
              ∆sharedlib←'libconga{CongaVersion}ssl',(⍕⎕SE.SALTUtils.BITS),'.a'
          :EndSelect
      :EndIf
      :If CongaVersion≡''   ⍝ if no specific version is required
          CongaVersion←⊃('34' '35' '36' '**')[18 19 20⍳2⊃⎕vfi 2↑2⊃'.'⎕WG'APLVersion']
          'Cannot determine Conga-Version'⎕signal( CongaVersion≡'**' )/11
      :EndIf
      ∆sharedlib←('{CongaVersion}'⎕R CongaVersion)∆sharedlib
      ⍝ ⎕←'pre=',pre
      ⍝ ⎕←'pre2=',pre2
      :If 0=≢pre
          pre←pre2
      :EndIf
      ⍝ ⎕←'pre=',pre
      ⍝ ⎕←'∆sharedlib=',∆sharedlib
      R←pre,∆sharedlib
      :If ' '∊R
          R←'"',R,'"'
      :EndIf
      ⍝ ⎕←'sharedlib=',R
    ∇

    ∇ r←name ∆init size;name
      :If 0=⎕NC name←'nettle_',name,'_init'
          ⎕NA sharedlib,'|',name,' >I1[',(⍕size),']'
      :EndIf
      r←(⍎name)size
    ∇

    ∇ r←name ∆initkey(size key);name
      :If 0=⎕NC name←'nettle_',name,'_set_key'
          ⎕NA sharedlib,'|',name,' >I1[',(⍕3×size),'] U8 <T1[]'
      :EndIf
      r←(⍎name)(3×size)(⍴key)key
    ∇


    ∇ r←name ∆update(ctx data)
      :If 0=⎕NC name←'nettle_',name,'_update'
          ⎕NA sharedlib,'|',name,' =I1[',(⍕≢ctx),'] U8 <T1[]'
      :EndIf
      r←(⍎name)ctx(⍴data)data
    ∇
    ∇ r←name ∆digest(ctx dsize)
      :If 0=⎕NC name←'nettle_',name,'_digest'
          ⎕NA sharedlib,'|',name,' =I1[',(⍕≢ctx),'] U8 >I1[',(⍕dsize),']'
      :EndIf
      r←(⍎name)ctx dsize dsize
    ∇

    ∇ r←MD5 data;ctx;digest
      :Access public Shared
      ctx←'md5'∆init 96
      ctx←'md5'∆update ctx data
      (ctx digest)←'md5'∆digest ctx 16
      r←digest
    ∇

    ∇ r←Ripemd160 data;ctx;digest
      :Access public Shared
      ctx←'ripemd160'∆init 112
      ctx←'ripemd160'∆update ctx data
      (ctx digest)←'ripemd160'∆digest ctx 20
      r←digest
    ∇

    ∇ r←Sha1 data;ctx;digest
      :Access public Shared
      ctx←'sha1'∆init 112
      ctx←'sha1'∆update ctx data
      (ctx digest)←'sha1'∆digest ctx 20
      r←digest
    ∇

    ∇ r←Sha3_224 data;ctx;digest
      :Access public Shared
      ctx←'sha3_224'∆init 352
      ctx←'sha3_224'∆update ctx data
      (ctx digest)←'sha3_224'∆digest ctx 28
      r←digest
    ∇
    ∇ r←Sha3_256 data;ctx;digest
      :Access public Shared
      ctx←'sha3_256'∆init 344
      ctx←'sha3_256'∆update ctx data
      (ctx digest)←'sha3_256'∆digest ctx 32
      r←digest
    ∇
    ∇ r←Sha3_384 data;ctx;digest
      :Access public Shared
      ctx←'sha3_384'∆init 312
      ctx←'sha3_384'∆update ctx data
      (ctx digest)←'sha3_384'∆digest ctx 48
      r←digest
    ∇
    ∇ r←Sha3_512 data;ctx;digest
      :Access public Shared
      ctx←'sha3_512'∆init 352
      ctx←'sha3_512'∆update ctx data
      (ctx digest)←'sha3_512'∆digest ctx 64
      r←digest
    ∇


    ∇ r←Sha256 data;ctx;digest
      :Access public Shared
      ctx←'sha256'∆init 112
      ctx←'sha256'∆update ctx data
      (ctx digest)←'sha256'∆digest ctx 32
      r←digest
    ∇

    ∇ r←key Hmac_Sha256 data;ctx;digest
      :Access public Shared
      ctx←'hmac_sha256'∆initkey 112 key
      ctx←'hmac_sha256'∆update ctx data
      (ctx digest)←'hmac_sha256'∆digest ctx 32
      r←digest
    ∇


    ∇ r←Sha224 data;ctx;digest
      :Access public Shared
      ctx←'sha224'∆init 112
      ctx←'sha256'∆update ctx data
      (ctx digest)←'sha224'∆digest ctx 28
      r←digest
    ∇

    ∇ r←key Hmac_Sha224 data;ctx;digest
      :Access public Shared
      ctx←'hmac_sha224'∆initkey 112 key
      ctx←'hmac_sha256'∆update ctx data
      (ctx digest)←'hmac_sha224'∆digest ctx 28
      r←digest
    ∇

    ∇ r←Sha512 data;ctx;digest
      :Access public Shared
      ctx←'sha512'∆init 216
      ctx←'sha512'∆update ctx data
      (ctx digest)←'sha512'∆digest ctx 64
      r←digest
    ∇

    ∇ r←Sha512_224 data;ctx;digest
      :Access public Shared
      ctx←'sha512_224'∆init 216
      ctx←'sha512'∆update ctx data
      (ctx digest)←'sha512_224'∆digest ctx 28
      r←digest
    ∇

    ∇ r←Sha512_256 data;ctx;digest
      :Access public Shared
      ctx←'sha512_256'∆init 216
      ctx←'sha512'∆update ctx data
      (ctx digest)←'sha512_256'∆digest ctx 32
      r←digest
    ∇


    ∇ r←key Hmac_Sha512 data;ctx;digest
      :Access public Shared
      ctx←'hmac_sha512'∆initkey 216 key
      ctx←'hmac_sha512'∆update ctx data
      (ctx digest)←'hmac_sha512'∆digest ctx 64
      r←digest
    ∇

    ∇ r←Sha384 data;ctx;digest
      :Access public Shared
      ctx←'sha384'∆init 216
      ctx←'sha512'∆update ctx data
      (ctx digest)←'sha384'∆digest ctx 48
      r←digest
    ∇

    ∇ r←key Hmac_Sha384 data;ctx;digest
      :Access public Shared
      ctx←'hmac_sha384'∆initkey 216 key
      ctx←'hmac_sha512'∆update ctx data
      (ctx digest)←'hmac_sha384'∆digest ctx 48
      r←digest
    ∇

    ∇ r←arg QA1 data;h;d;hash;key
      :If 1=≡arg
          hash←arg
          h←⎕NEW Hash hash
      :Else
          (hash key)←arg
          h←⎕NEW Hash(hash key)
      :EndIf
      h.Data¨{(1,¯1↓' '=⍵)⊂⍵}data
      d←h.Digest
      :If 1=≡arg
          r←d≡(⍎hash)data
      :Else
          r←d≡key(⍎'Hmac_'{⍺≡(≢⍺)↑⍵:⍵ ⋄ ⍺,⍵}hash)data
      :EndIf
    ∇


    ∇ r←QA
      :Access shared public
      r←1
      r∧←(hex MD5'Dette er en test')≡'85651648f6976a16a44254860cbacf9e'
      r∧←(hex Sha1'Dette er en test')≡'5a27363f823ecf20a7722f445a35aa77bd5ea236'
      r∧←(hex Sha224'Dette er en test')≡'1c76a2f9c74831c369d5a3aade1bf493c1d5a43f68baa3f6420963a6'
      r∧←(hex Sha256'Dette er en test')≡'3757d63c07c165a3bee2c1e8890e7c3e7986f95a51acdb2f8724c9efc361eefc'
      r∧←(hex Sha384'Dette er en test')≡'1e3e65f4619b34723e1a1b52ea613730a862f3c0375ec44302d2b3c7bdb95afe6eb579f60d313255b39b819016abca84'
      r∧←(hex Sha512'Dette er en test')≡'9f287f969005d968ab40f70dd3add8a269f8f9be283abca37b5a60919aa62c7faa5907537a3fb4bf39f890fc1d5fa33e9d9bcab921ea34f19aafb36d1de00c10'
     
      r∧←(hex'klyp'Hmac_Sha224'Dette er en test')≡'de9ebebdb41b5283ef870e4e32723f2c62a77ef42fafacaccff24c95'
      r∧←(hex'klyp'Hmac_Sha256'Dette er en test')≡'1c09677f8bd350df35790a70874bf96f8cab330b9c06439ebf658f97b2ada24a'
      r∧←(hex'klyp'Hmac_Sha384'Dette er en test')≡'9e818fcbd2044f9b71467bf2de7f5c82eed0e8119e6e4394e1c824d3940dc1579ff832da8eed641bddd1ae7ea353cf43'
      r∧←(hex'klyp'Hmac_Sha512'Dette er en test')≡'ef7914e69c8dd582eb325bf26b03a74d0fe78cbc3f92a4d6789a85ed0f3a194f0bbaa592594ff38f0ef2442c0c87d497ebaf6664c0b47857e226012cea48e75e'
      r∧←'Sha224'QA1'Dette er en test'
      r∧←'Sha256'QA1'Dette er en test'
      r∧←'Sha384'QA1'Dette er en test'
      r∧←'Sha512'QA1'Dette er en test'
      r∧←'Sha224' 'klyp'QA1'Dette er en test'
      r∧←'Sha256' 'klyp'QA1'Dette er en test'
      r∧←'Sha384' 'klyp'QA1'Dette er en test'
      r∧←'Sha512' 'klyp'QA1'Dette er en test'
    ∇

    ∇ Init;csize
      :Select hash
      :Case 'sha224'
          (csize dsize)←112 28
      :Case 'sha256'
          (csize dsize)←112 32
      :Case 'sha384'
          (csize dsize)←216 48
      :Case 'sha512'
          (csize dsize)←216 64
      :Else
          (hash,' not implemented yet')⎕SIGNAL 16
      :EndSelect
      :If key≡⍬
          ctx←hash ∆init csize
      :Else
          hash←'hmac_'{⍺≡(≢⍺)↑⍵:⍵ ⋄ ⍺,⍵}hash
          ctx←hash ∆initkey csize key
      :EndIf
    ∇


    ∇ Make
      :Access public
      :Implements constructor
      hash←'sha256'
      key←⍬
      Init
    ∇

    ∇ Make1 ahash
      :Access public
      :Implements constructor
      hash←⎕C ahash
      key←⍬
      Init
    ∇

    ∇ Make2(ahash akey)
      :Access public
      :Implements constructor
      hash←⎕C ahash
      key←akey
     
      Init
    ∇



    ∇ Data data;hh
      :Access public
      :Select '_'{(1-(⌽⍵)⍳⍺)↑⍵}hash
      :Case 'sha224'
          hh←(¯6↓hash),'sha256'
      :Case 'sha384'
          hh←hh←(¯6↓hash),'sha512'
      :Else
          hh←hash
      :EndSelect
      ctx←hh ∆update ctx data
    ∇

    ∇ r←Digest
      :Access public
      (ctx r)←hash ∆digest ctx dsize
    ∇



:EndClass
