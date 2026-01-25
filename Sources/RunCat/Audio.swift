import _Volatile

struct Audio {
    private var soundControlX = VolatileMappedRegister<UInt16>(unsafeBitPattern: 0x04000084)
    private var soundControlL = VolatileMappedRegister<UInt16>(unsafeBitPattern: 0x04000080)
    private var soundControlH = VolatileMappedRegister<UInt16>(unsafeBitPattern: 0x04000082)

    private var timer0Data = VolatileMappedRegister<UInt16>(unsafeBitPattern: 0x04000100)
    private var timer0Control = VolatileMappedRegister<UInt16>(unsafeBitPattern: 0x04000102)

    private var dma1SourceAddress = VolatileMappedRegister<UInt32>(unsafeBitPattern: 0x040000BC)
    private var dma1DestinationAddress = VolatileMappedRegister<UInt32>(unsafeBitPattern: 0x040000C0)
    private var dma1Control = VolatileMappedRegister<UInt32>(unsafeBitPattern: 0x040000C4)

    private let fifoAAddress: UInt32 = 0x040000A0


    init() {
        soundControlX.store(0x0080)
        soundControlL.store(0x2277)
        soundControlH.store(0x0002)
    }

    func play(soundEffect: SoundEffect) -> UInt16 {
        dma1Control.store(0)
        timer0Control.store(0)
        soundControlL.store(0)

        let dmaARightEnable: UInt16 = 1 << 8
        let dmaALeftEnable: UInt16 = 1 << 9
        let dmaATimerSelect: UInt16 = 0
        let dmaAFifoReset: UInt16 = 1 << 11
        let dmaAVolumeFull: UInt16 = 1 << 2
        soundControlH.store(
            dmaARightEnable | dmaALeftEnable | dmaATimerSelect | dmaAFifoReset | dmaAVolumeFull
        )

        soundControlH.store(
            dmaARightEnable | dmaALeftEnable | dmaATimerSelect | dmaAVolumeFull
        )

        let timerReload = UInt16(truncatingIfNeeded: 65536 - (16777216 / UInt32(SoundEffect.sampleRate)))
        timer0Data.store(timerReload)

        soundEffect.data.withUnsafeBufferPointer { buffer in
            guard let pointer = buffer.baseAddress else { return }
            let sourceAddress = UInt32(UInt(bitPattern: pointer))
            dma1SourceAddress.store(sourceAddress)
        }
        dma1DestinationAddress.store(fifoAAddress)

        let destinationFixed: UInt32 = 2 << 21
        let sourceIncrement: UInt32 = 0 << 23
        let repeatEnable: UInt32 = 1 << 25
        let transfer32Bit: UInt32 = 1 << 26
        let startTimingFifo: UInt32 = 3 << 28
        let dmaEnable: UInt32 = 1 << 31
        dma1Control.store(
            destinationFixed | sourceIncrement | repeatEnable | transfer32Bit | startTimingFifo | dmaEnable
        )

        let timerEnable: UInt16 = 1 << 7
        timer0Control.store(timerEnable)

        return UInt16((soundEffect.sampleCount * 60) / Int(SoundEffect.sampleRate)) + 2
    }

    func stop() {
        timer0Control.store(0)
        dma1Control.store(0)
    }
}
