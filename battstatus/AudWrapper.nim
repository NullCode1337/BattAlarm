# Modded from https://github.com/paranim/parasound/blob/master/tests/common.nim
import parasound/dr_wav
import parasound/miniaudio
import os

proc play*(data: string | seq[uint8], sleepMsecs: int) =
  ## if `data` is a string, it is interpreted as a filename.
  ## if `data` is a byte sequence, it is interpreted as an in-memory buffer.
  var
    decoder = newSeq[uint8](ma_decoder_size())
    decoderAddr = cast[ptr ma_decoder](decoder[0].addr)
    deviceConfig = newSeq[uint8](ma_device_config_size())
    deviceConfigAddr = cast[ptr ma_device_config](deviceConfig[0].addr)
    device = newSeq[uint8](ma_device_size())
    deviceAddr = cast[ptr ma_device](device[0].addr)
  when data is string: doAssert MA_SUCCESS == ma_decoder_init_file(data, nil, decoderAddr)
  elif data is seq[uint8]: doAssert MA_SUCCESS == ma_decoder_init_memory(data[0].unsafeAddr, data.len, nil, decoderAddr)

  proc data_callback(pDevice: ptr ma_device; pOutput: pointer; pInput: pointer; frameCount: ma_uint32) {.cdecl.} =
    let decoderAddr = ma_device_get_decoder(pDevice)
    discard ma_decoder_read_pcm_frames(decoderAddr, pOutput, frameCount)

  ma_device_config_init_with_decoder(deviceConfigAddr, ma_device_type_playback, decoderAddr, data_callback)
  if ma_device_init(nil, deviceConfigAddr, deviceAddr) != MA_SUCCESS:
    discard ma_decoder_uninit(decoderAddr)
    quit("Failed to open playback device.")

  if ma_device_start(deviceAddr) != MA_SUCCESS:
    ma_device_uninit(deviceAddr)
    discard ma_decoder_uninit(decoderAddr)
    quit("Failed to start playback device.")

  sleep(sleepMsecs)
  discard ma_device_stop(deviceAddr)
  ma_device_uninit(deviceAddr)
  discard ma_decoder_uninit(decoderAddr)
