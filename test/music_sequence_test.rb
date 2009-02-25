require File.join(File.dirname(__FILE__), 'test_helper.rb')
require 'tempfile'

class MusicSequenceTest < Test::Unit::TestCase
  def setup
    @sequence = MusicSequence.new
    
    @tempo = @sequence.tracks.tempo
    @tempo.add 0.0, ExtendedTempoEvent.new(:bpm => 120)
    
    @track = @sequence.tracks.new
    @track.add 0.0, MIDIProgramChangeMessage.new(:channel => 0, :program => 1)
    @track.add 0.0, MIDINoteMessage.new(:note => 60)
    @track.add 1.0, MIDINoteMessage.new(:note => 64)
    @track.add 2.0, MIDINoteMessage.new(:note => 67)
  end
  
  def test_type
    assert_equal :beat, @sequence.type, "Expected default type of :beat."
    seq = MusicSequence.new
    seq.type = :samp
    assert_equal :samp, seq.type
    seq.type = :secs
    assert_equal :secs, seq.type
  end
  
  def test_save_with_pathname
    tmp = Tempfile.new('music_sequence_test.mid')
    assert_nothing_raised { @sequence.save(tmp.path) }
    assert File.exists?(tmp.path)
  end
  
  def test_tracks
    assert_kind_of MusicTrackCollection, @sequence.tracks
    assert_equal @sequence.tracks, @sequence.tracks,
      "Expected only one instance of the track collection."
  end
end
